-module(websaferl).

-export([encode/1]).
-export([decode/1]).

encode(Buffer)->
  websafe_encode(base64:encode(Buffer)).

decode(Buffer)->
  base64:decode(websafe_decode(Buffer)).

websafe_encode(Buffer)->
  << <<(websafe_encode_char(B))/binary>> || <<B>> <= Buffer >>.

websafe_encode_char($=) -> <<>>;
websafe_encode_char($+) -> <<"-">>;
websafe_encode_char($/) -> <<"_">>;
websafe_encode_char(C) -> <<C>>.

websafe_decode(Buffer)->
  pad(<< <<(websafe_decode_char(B))/binary>> || <<B>> <= Buffer >>).

websafe_decode_char($-) -> <<"+">>;
websafe_decode_char($_) -> <<"/">>;
websafe_decode_char(C) -> <<C>>.

pad(Buffer)->
  case byte_size(Buffer) rem 4 of
    0 -> Buffer;
    Diff -> pad(Buffer, 4-Diff)
  end.

pad(Buffer, 0)->
  Buffer;
pad(Buffer, 1)->
  <<Buffer/binary,"=">>;
pad(Buffer, 2)->
  <<Buffer/binary,"==">>;
pad(Buffer, 3)->
  <<Buffer/binary,"===">>.
