require 'serialport' # http://rubydoc.info/gems/serialport/1.1.0/frames 

class SerialPortConnectionError < RuntimeError; end

class SerialPortProfile

  def initialize(device, serial_port_connection_class=SerialPort)
    raise ArgumentError.new('device must be non-nil') if device.nil?

    @device = device
    @connection_class = serial_port_connection_class
    @connection = nil
  end

  def connect
    establish_connection if @connection.nil?
  end


  def send_data_package(package)

  end

  def receive_data_package

  end

  def settings
    {
      'baud' => 57600,
      'data_bits' => 8,
      'stop_bits' => 1,
      'parity' => ::SerialPort::NONE,
      'flow_control' => ::SerialPort::HARD,
      'read_timeout' => 5000
    }

  end


  private
  def establish_connection
    @connection = @connection_class.new(
      @device,
      settings['baud'],
      settings['data_bits'],
      settings['stop_bits'],
      settings['parity']
    )

    unless @connection.nil?
      set_post_connection_controls
    else
      raise SerialPortConnectionError, "Could not establish a SerialPortProfile connection to #{@device}"
    end
  end

  def set_post_connection_controls
    @connection.flow_control = settings['flow_control']
    @connection.read_timeout = settings['read_timeout']
  end
end
