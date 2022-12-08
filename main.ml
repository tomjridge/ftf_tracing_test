open Tracing
module Time_ns = Core.Time_ns

let base_time = None

let filename = "test.fxt"

let f = Trace.create_for_file ~base_time:None ~filename

let thread = Trace.allocate_thread f ~pid:1 ~name:"Thread 1"

let begin_,end_ = 
  Trace.(write_duration_begin f ~args:[] ~thread ~category:"some cat",
         write_duration_end f ~args:[]~thread ~category:"some cat")

let int_to_span i = Time_ns.Span.of_int_ns i

let _ = 
  begin_ ~name:"evt1" ~time:(int_to_span 0);
  end_ ~name:"evt1" ~time:(int_to_span 100);
  begin_ ~name:"evt2" ~time:(int_to_span 200);
  begin_ ~name:"evt3" ~time:(int_to_span 240);
  end_ ~name:"evt3" ~time:(int_to_span 260);
  end_ ~name:"evt2" ~time:(int_to_span 300);
  Trace.close f

let _ = Printf.printf "Sample trace written to file %s\n" filename

(* NOTE when loaded in Perfetto, the timestamps are all off by 100 - for example, evt1
   starts at 100ns rather than 0; possibly due to incorrect use of spans above? *)
