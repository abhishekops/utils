require 'redis'

def redis_scan
	redis 								= Redis.new(host: "127.0.0.1", port: 6379)
	keys  								= []
	cursor, iterated, iteration_count 	= 0, 0, 0 
	key_pattern 						= "*"

	loop do
		result = redis.scan(cursor, :match => key_pattern, :count => 1000)
		# Response will be of the form [cursor, [array of matched keys]]
		cursor = result.first
		iterated = iterated + result[1].size
		keys = keys + result[1]
		iteration_count = iteration_count + 1
		if iteration_count % 10 == 0
			puts "sleeping for 1 second after every 5 scans"
			sleep(0.2)
		end	
		break if cursor == "0"
	end
	
	p iterated
	p iteration_count
	p keys
end
