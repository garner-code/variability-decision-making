function [rt, sub_resp] = run_memory_probe(prbs_on,window, edgeRect, backRect, ...
                                            edge_col, col, doorRects, ...
                                            doors_closed_cols, ...
                                            xCenter, yCenter, prb_locs,...
                                            tgt_ids, trial_start, resp, ...
                                            time)
  waiting_for_resp = 1;
  vbl = prbs_on;
  resp_waitframes = 1;

  while waiting_for_resp

      draw_mts_tgts(window, edgeRect, backRect, ...
          edge_col, col, doorRects, doors_closed_cols,...
          xCenter, yCenter, prb_locs, tgt_ids, trial_start);

      [~, secs, key_code] = KbCheck;
      if key_code(resp.same)

          sub_resp = 0;
          waiting_for_resp = 0;
      elseif key_code(resp.diff)

          sub_resp = 1;
          waiting_for_resp = 0;
      end
      vbl = Screen('Flip', window, vbl + (resp_waitframes - 0.5) * time.ifi);
  end
  rt = secs - prbs_on;

end