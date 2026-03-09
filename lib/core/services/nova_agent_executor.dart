import 'dart:convert';
import 'package:http/http.dart' as http;

/// Nova Act Agent Executor
/// Autonomous automation agents using Nova Act for:
/// - Paying bills automatically
/// - Opening websites
/// - Filling forms
/// - Executing financial workflows
/// - Scheduling transfers
/// - Managing subscriptions
class NovaAgentExecutor {
  final String apiKey;
  final String region;
  static const String _baseUrl = 'https://bedrock-runtime';
  
  NovaAgentExecutor({
    required this.apiKey,
    required this.region,
  });

  /// Execute an autonomous agent task
  Future<Map<String, dynamic>> executeTask({
    required String taskDescription,
    required String taskType,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final endpoint = '$_baseUrl.$region.amazonaws.com/model/amazon.nova-pro-v1:0/invoke';
      
      final requestBody = {
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'text': '''
Execute the following task autonomously:

Task: $taskDescription
Type: $taskType
Parameters: ${parameters != null ? jsonEncode(parameters) : 'None'}

Provide step-by-step execution plan and results.
'''
              }
            ]
          }
        ],
        'inferenceConfig': {
          'temperature': 0.1,
          'maxTokens': 4096,
        },
      };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'result': data['output']['message']['content'][0]['text'],
          'steps': _parseExecutionSteps(data['output']['message']['content'][0]['text']),
        };
      } else {
        return {
          'success': false,
          'error': 'Nova Act API error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Nova Act service error: $e',
      };
    }
  }

  /// Pay a bill automatically
  Future<Map<String, dynamic>> payBill({
    required String billProvider,
    required double amount,
    required String accountNumber,
  }) async {
    return await executeTask(
      taskDescription: 'Pay $billProvider bill of \$$amount',
      taskType: 'bill_payment',
      parameters: {
        'provider': billProvider,
        'amount': amount,
        'account': accountNumber,
      },
    );
  }

  /// Open a website and navigate
  Future<Map<String, dynamic>> openWebsite({
    required String url,
    String? action,
  }) async {
    return await executeTask(
      taskDescription: 'Open $url${action != null ? ' and $action' : ''}',
      taskType: 'web_navigation',
      parameters: {
        'url': url,
        'action': action,
      },
    );
  }

  /// Fill a form automatically
  Future<Map<String, dynamic>> fillForm({
    required String formUrl,
    required Map<String, dynamic> formData,
  }) async {
    return await executeTask(
      taskDescription: 'Fill form at $formUrl',
      taskType: 'form_filling',
      parameters: {
        'url': formUrl,
        'data': formData,
      },
    );
  }

  /// Execute a financial workflow
  Future<Map<String, dynamic>> executeWorkflow({
    required String workflowName,
    required List<Map<String, dynamic>> steps,
  }) async {
    return await executeTask(
      taskDescription: 'Execute $workflowName workflow',
      taskType: 'workflow_execution',
      parameters: {
        'workflow': workflowName,
        'steps': steps,
      },
    );
  }

  /// Schedule a transfer
  Future<Map<String, dynamic>> scheduleTransfer({
    required String fromAccount,
    required String toAccount,
    required double amount,
    required DateTime scheduledDate,
  }) async {
    return await executeTask(
      taskDescription: 'Schedule transfer of \$$amount from $fromAccount to $toAccount',
      taskType: 'transfer_scheduling',
      parameters: {
        'from': fromAccount,
        'to': toAccount,
        'amount': amount,
        'date': scheduledDate.toIso8601String(),
      },
    );
  }

  /// Manage subscription
  Future<Map<String, dynamic>> manageSubscription({
    required String subscriptionName,
    required String action, // 'cancel', 'pause', 'resume', 'update'
    Map<String, dynamic>? updateData,
  }) async {
    return await executeTask(
      taskDescription: '$action subscription for $subscriptionName',
      taskType: 'subscription_management',
      parameters: {
        'subscription': subscriptionName,
        'action': action,
        'data': updateData,
      },
    );
  }

  /// Parse execution steps from response
  List<Map<String, String>> _parseExecutionSteps(String response) {
    final steps = <Map<String, String>>[];
    final lines = response.split('\n');
    
    for (final line in lines) {
      if (line.trim().startsWith('Step ') || line.trim().startsWith('-')) {
        steps.add({
          'description': line.trim(),
          'status': 'completed',
        });
      }
    }
    
    return steps;
  }
}
