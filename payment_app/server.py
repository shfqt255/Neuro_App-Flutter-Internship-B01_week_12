from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import stripe

# Your Stripe Secret Key
stripe.api_key = "Your Secret Key"

class PaymentHandler(BaseHTTPRequestHandler):
    
    def do_OPTIONS(self):
        """Handle CORS preflight requests"""
        self.send_response(204)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    
    def do_GET(self):
        """Handle GET requests - Browser access"""
        if self.path == '/' or self.path == '/test':
            # Show a nice test page
            html = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>Stripe Payment Server</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        max-width: 800px;
                        margin: 50px auto;
                        padding: 20px;
                        background: #f5f5f5;
                    }
                    .container {
                        background: white;
                        padding: 30px;
                        border-radius: 10px;
                        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    }
                    .status {
                        color: #4CAF50;
                        font-weight: bold;
                    }
                    .endpoint {
                        background: #f0f0f0;
                        padding: 10px;
                        border-radius: 5px;
                        font-family: monospace;
                        margin: 10px 0;
                    }
                    button {
                        background: #635BFF;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 5px;
                        cursor: pointer;
                        font-size: 16px;
                    }
                    button:hover {
                        background: #4a45cc;
                    }
                    #result {
                        margin-top: 20px;
                        padding: 15px;
                        background: #f0f0f0;
                        border-radius: 5px;
                        display: none;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>Stripe Payment Server</h1>
                    <p class="status"> Server is running!</p>
                    
                    <h3>Payment Endpoint:</h3>
                    <div class="endpoint">POST http://192.168.100.143:5000/payment/create-payment-intent</div>
                    
                    <h3>Quick Test (200 PKR):</h3>
                    <button onclick="testPayment()">Test Payment Endpoint</button>
                    
                    <div id="result"></div>
                </div>
                
                <script>
                    async function testPayment() {
                        const result = document.getElementById('result');
                        result.style.display = 'block';
                        result.innerHTML = 'Creating payment intent...';
                        
                        try {
                            const response = await fetch('http://192.168.100.143:5000/payment/create-payment-intent', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json',
                                },
                                body: JSON.stringify({
                                    amount: '20000',  // 200 PKR in paisas
                                    currency: 'pkr'
                                })
                            });
                            
                            const data = await response.json();
                            result.innerHTML = `
                                <h3> Success!</h3>
                                <pre>${JSON.stringify(data, null, 2)}</pre>
                                <p><strong>Client Secret:</strong> ${data.clientSecret}</p>
                                <p><strong>Payment ID:</strong> ${data.id}</p>
                            `;
                        } catch (error) {
                            result.innerHTML = `<h3> Error:</h3><p>${error.message}</p>`;
                        }
                    }
                </script>
            </body>
            </html>
            """
            
            self.send_response(200)
            self.send_header('Content-Type', 'text/html')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(html.encode())
        else:
            self.send_response(404)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({'error': 'Not found'}).encode())
    
    def do_POST(self):
        """Handle POST requests"""
        if self.path == '/payment/create-payment-intent':
            try:
                # Read request body
                content_length = int(self.headers['Content-Length'])
                post_data = self.rfile.read(content_length)
                data = json.loads(post_data)
                
                # Extract amount and currency
                amount = data.get('amount')
                currency = data.get('currency', 'pkr')
                
                print(f"Creating payment intent: {amount} {currency}")
                
                # Check minimum amount for PKR (200 PKR = minimum ~$0.50 USD)
                if currency.lower() == 'pkr' and int(amount) < 20000:
                    error_response = {
                        'error': f'Minimum amount is 200 PKR (approximately $0.50 USD). You sent {amount} paisas.',
                        'status': 'error',
                        'minimum_amount': '20000'  # 200 PKR in paisas
                    }
                    self.send_response(400)
                    self.send_header('Content-Type', 'application/json')
                    self.send_header('Access-Control-Allow-Origin', '*')
                    self.end_headers()
                    self.wfile.write(json.dumps(error_response).encode())
                    print(f"Amount too small: {amount} paisas")
                    return
                
                # Create Stripe Payment Intent
                intent = stripe.PaymentIntent.create(
                    amount=int(amount),
                    currency=currency,
                )
                
                # Success response
                response_data = {
                    'clientSecret': intent.client_secret,
                    'id': intent.id,
                    'status': 'success',
                    'amount': amount,
                    'currency': currency
                }
                
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps(response_data).encode())
                
                print(f"Payment intent created: {intent.id}")
                
            except stripe.error.InvalidRequestError as e:
                error_data = {'error': str(e), 'status': 'error'}
                self.send_response(400)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps(error_data).encode())
                print(f"Stripe error: {str(e)}")
                
            except Exception as e:
                error_data = {'error': str(e), 'status': 'error'}
                self.send_response(500)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps(error_data).encode())
                print(f"Error: {str(e)}")
        
        else:
            self.send_response(404)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({'error': 'Endpoint not found'}).encode())
    
    def log_message(self, format, *args):
        """Custom log format"""
        print(f"📡 {args[0]}")

# Start server
if __name__ == '__main__':
    PORT = 5000
    # Listen on all network interfaces so phone can connect
    server = HTTPServer(('0.0.0.0', PORT), PaymentHandler)
    print(f"""
  Local:   http://localhost:{PORT}
  Phone:   http://192.168.100.143:{PORT}
  Test:    http://192.168.100.143:{PORT}/test
  API:     POST /payment/create-payment-intent
  Minimum: 200 PKR (20000 paisas)
  Stop:    Press Ctrl+C
    """)
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("Server stopped")
        server.server_close()