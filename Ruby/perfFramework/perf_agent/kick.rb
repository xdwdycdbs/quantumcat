require 'config'

@operation = ARGV[0]
@username = ARGV[1]
@password = ARGV[2]
@machineid = ARGV[3]
@prefix = ARGV[4]
@count = ARGV[5]
@depth = ARGV[6]
@folder_syzygy = ARGV[7]
@resumable = ARGV[8]
@size_ds = ARGV[9]
@datasource = ARGV[10]
@tdsIndex = ARGV[11].to_i

@result = ''
cmd = ''

logFileName = "perf" + Time.now.strftime("%Y%m%d%H%M%S") + @username + ".log"
@logFile = File.new(logFileName, 'w')

if @operation == 'put'
    if @folder_syzygy == '1'
        cmd = "./pl#{@operation} -t http://#{$tds_list[@tdsIndex]} -u #{@username} -p #{@password} -m #{@machineid} -f #{@prefix} -r #{@datasource} -s #{@size_ds} -c #{@count} -d #{@depth} -l #{@resumable} -z #{@folder_syzygy}"
    else
	cmd = "./pl#{@operation} -t http://#{$tds_list[@tdsIndex]} -u #{@username} -p #{@password} -m #{@machineid} -f #{@prefix} -s #{@size_ds} -c #{@count} -d #{@depth} -l #{@resumable} -z #{@folder_syzygy}"
    end
elsif @operation == 'get'
    if @folder_syzygy == '0'
        cmd = "./pl#{@operation} http://#{$tds_list[@tdsIndex]} #{@username} #{@password} #{@machineid} #{@prefix} #{@depth} #{@count}"
    else
        cmd = "./pl#{@operation} http://#{$tds_list[@tdsIndex]} #{@username} #{@password} #{@machineid} #{@prefix} #{@depth} #{@count} 'syzygy'"
    end
elsif @operation == 'delete'
    cmd = "./pl#{@operation} -t http://#{$tds_list[@tdsIndex]} -u #{@username} -p #{@password} -m #{@machineid} -f #{@prefix} -d #{@depth} -c #{@count} -r #{@folder_syzygy}"
elsif @operation == 'mkdir'
    cmd = "./pl#{@operation} -t http://#{$tds_list[@tdsIndex]} -u #{@username} -p #{@password} -m #{@machineid} -f #{@prefix} -d #{@depth} -c #{@count}"
end

puts cmd
@logResult = 'Success'
@result = `#{cmd}`
@result.each_line do |line|
   if line.strip != '200'
      @logResult = 'Fail'
	  break
	  end
end

postfex = @operation.upcase
timeLog = File.open("#{@username}_#{postfex}.log", 'r')
time = timeLog.readline.strip.to_f/1000000
timeLog.close

@logFile.puts(Time.now.strftime("%Y%m%d%H%M%S").to_s + "|" + @operation + "|" + @username + "|" + @logResult.strip  + "|" + time.to_s + "\n")
@logFile.close

#announce server
`ruby announce.rb #{logFileName}`
