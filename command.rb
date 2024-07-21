require 'open3'

class Command
    def to_s
        "/opt/slurm/current/bin/squeue"
    end

    AppProcess = Struct.new(:job_id, :partition, :name, :user, :st, :time, :nodes, :nodelist)

    def parse(output)
        lines = output.strip.split("\n")
        lines = lines.drop(1) #Drop the first row
        lines.map do |line|
            fields = line.split(/\s+/) # Split based on one or more spaces
            AppProcess.new(*fields)
        end
    end

    def exec
        proceses, error = [], nil

        stdout, stderr, status = Open3.capture3(to_s)
        output = stdout + stderr
        
        processes = parse(output) if status.success?

        [processes, error]
    end
end