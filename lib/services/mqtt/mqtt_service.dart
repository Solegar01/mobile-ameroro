import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';

class MqttService extends GetxService {
  final connectivityService = Get.find<ConnectivityService>();
  MqttServerClient? _client;

  final String _broker = 'mqtt.higertech.com';
  final String _brokerID = 'ameroro.mobile';
  final String _username = 'higertech';
  final String _password = '1MTY7mBp1sUuEFc';

  var receivedMessage = RxString('');
  var topicMessages = <String, String>{}.obs;
  var connectionStatus = RxString('Disconnected');

  Future<MqttService> initialize() async {
    if (isClientInitializedAndConnected()) {
      print("MQTT client is already initialized and connected.");
      return this;
    }

    _client = MqttServerClient.withPort(_broker, _brokerID, 1883);
    _client!.keepAlivePeriod = 60;
    _client!.logging(on: true);
    _client!.secure = false;
    _client!.onBadCertificate = (dynamic certificate) => true; // For testing

    _client!.onConnected = onConnected;
    _client!.onDisconnected = onDisconnected;
    _client!.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(_brokerID)
        .authenticateAs(_username, _password)
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client!.connectionMessage = connMessage;

    return this;
  }

  // Check if the client is initialized and connected
  bool isClientInitializedAndConnected() {
    if (_client == null) {
      print("MQTT client is not initialized.");
      return false;
    }

    if (_client!.connectionStatus == null ||
        _client!.connectionStatus!.state != MqttConnectionState.connected) {
      print("MQTT client is not connected.");
      return false;
    }

    print("MQTT client is initialized and connected.");
    return true;
  }

  Future<void> connectWithRetry(int retries) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        await _client!.connect();
        if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
          print('Connected to MQTT broker on attempt $attempt');
          updateConnectionStatus();
          return;
        }
      } catch (e) {
        print('Connection attempt $attempt failed: $e');
      }
      attempt++;
      await Future.delayed(Duration(seconds: 2 * attempt));
    }
    print('Failed to connect MQTT service after $retries attempts');
  }

  Future<void> handleDisconnection() async {
    int retries = 3;
    for (int attempt = 1; attempt <= retries; attempt++) {
      print('Attempting to reconnect (attempt $attempt/$retries)...');
      try {
        await _client!.connect();
        if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
          print('Reconnected successfully.');
          updateConnectionStatus();
          return;
        }
      } catch (e) {
        print('Reconnection failed: $e');
        await Future.delayed(
            Duration(seconds: attempt * 2)); // Exponential backoff
      }
    }
    print('Failed to reconnect after $retries attempts.');
  }

  Future<void> subscribeToTopic(String topic) async {
    if (!isClientInitializedAndConnected()) {
      print("Cannot subscribe to topic: $topic. MQTT client is not ready.");
      return;
    }

    // Check if the topic is already subscribed
    if (_client!.subscriptionsManager!.subscriptions.containsKey(topic)) {
      print("Already subscribed to topic: $topic");
      return;
    }

    _client!.subscribe(topic, MqttQos.atMostOnce);
    print('Subscribed to topic: $topic');
  }

  Future<void> subscribeToMultiTopic(List<String> topics) async {
    if (!isClientInitializedAndConnected()) {
      print("Cannot subscribe to topics. MQTT client is not ready.");
      return;
    }

    for (var topic in topics) {
      _client!.subscribe(topic, MqttQos.atMostOnce);
      print('Subscribed to topic: $topic');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (!isClientInitializedAndConnected()) {
      print("Cannot unsubscribe from topic: $topic. MQTT client is not ready.");
      return;
    }

    _client!.unsubscribe(topic);
    print('Unsubscribed from topic: $topic');
  }

  Future<void> publishMessage(String topic, String message,
      {bool retain = false}) async {
    if (!isClientInitializedAndConnected()) {
      print("Cannot publish message. MQTT client is not ready.");
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(
      topic,
      MqttQos.atMostOnce, // Adjust QoS level as needed
      builder.payload!,
      retain: retain, // Set retain flag here
    );
    print('Published message: $message to topic: $topic');
  }

  void onConnected() {
    print('Connected');
    updateConnectionStatus();
  }

  void onDisconnected() {
    print('Disconnected');
    updateConnectionStatus();
    handleDisconnection();
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void updateConnectionStatus() {
    connectionStatus.value =
        _client!.connectionStatus!.state == MqttConnectionState.connected
            ? 'Connected'
            : 'Disconnected';
  }

  void _setupConnectivityListener() {
    connectivityService.isConnected.listen(
      (bool isConnected) async {
        if (isConnected) {
          try {
            await connectWithRetry(3);
          } catch (e) {
            print('Failed to connect: $e');
            updateConnectionStatus();
          }
          _client!.updates!
              .listen((List<MqttReceivedMessage<MqttMessage>>? event) {
            final MqttPublishMessage message =
                event![0].payload as MqttPublishMessage;
            final topic = event[0].topic;
            final messageString = MqttPublishPayload.bytesToStringAsString(
                message.payload.message);

            topicMessages[topic] = messageString;
          });
        } else {
          _client!.disconnect();
        }
      },
    );
  }

  @override
  void onInit() async {
    await initialize();
    _setupConnectivityListener();
    super.onInit();
  }

  @override
  void onClose() {
    _client?.disconnect();
    super.onClose();
  }
}
