// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// XXXXX FILL IN HERE XXXXX
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// xfire_fpucordic.vh
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-03-16 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Definitions
// *****************************************************************************

// Define size for flags
`define FLO_FSIZE     3

// Definie size for opcode
`define OPSIZE    5

localparam E_SIZE_S  = 8;
localparam F_SIZE_S  = 23;
localparam E_SIZE_D  = 11;
localparam F_SIZE_D  = 52;

// Format types
//subtype  f_t is            std_logic;

localparam F_BIT_POS    = 0;        // 32 or 64 bit input
localparam F_TYPE_POS   = 1;        // Ffixed point or Floating point input

localparam F_32         = 0;          // 32 bits input
localparam F_64         = 1;          // 64 bits input
localparam F_FIX        = 0;          // Fixed input type
localparam F_FLO        = 1;          // Float input type

localparam FORMAT_SIZE  = 2;

//subtype  format_t is       std_logic_vector(FORMAT_SIZE-1 downto 0);

localparam F_INT             = 0;//"00";    // Integer input type
localparam F_LONG            = 1;//"01";    // Long input type
localparam F_SINGLE          = 2;//"10";    // 32-bit float (single) input type
localparam F_DOUBLE          = 3;//"11";    // 64-bit float (double) input type

// Cordic float flags
localparam FLO_FSIZE               = 4;

//subtype  flo_flags_t is          std_logic_vector(FLO_FSIZE-1 downto 0);
//subtype  flo_flag_position_t is  natural;

localparam FLO_FLAG_SIGNED_POS     = 5;   // S == Signed                      --> Indicates if the result is signed with a 1
localparam FLO_FLAG_NEGATIVE_POS   = 4;   // N == Negative                    --> Indicates if the result is negative with a 1
localparam FLO_FLAG_INF_POS        = 3;   // I == Infinite    --> Indicates that one of the floating point inputs is either neg or pos infinite
localparam FLO_FLAG_NAN_POS        = 2;   // Na == NaN  --> Indicates that one of the floating point inputs is NaN
localparam FLO_FLAG_OV_POS         = 1;   // V == Overflow or Signed overflow --> Indicates an overflow in the result with a 1
localparam FLO_FLAG_ZERO_POS       = 0;   // Z == Zero                        --> Indicates if the result is zero with a 1

// Output ranges
//subtype  range_t is              std_logic_vector(1 downto 0);

localparam RANGE_1        = 0;//"00";        // Indicates that the F parameter of the output is 1
localparam RANGE_2        = 1;//"01";        // Indicates that the F parameter of the output is 2
localparam RANGE_4        = 2;//"10";        // Indicates that the F parameter of the output is 4
localparam RANGE_180      = 3;//"11";        // Indicates that the F parameter of the output is 180
localparam RANGE_UNK      = 0;//"00";        // TODO: DEFINE RANGE FOR THESE OPS

// Number of bits for decimal part
//subtype dec_size_t is            std_logic_vector(5 downto 0);

localparam DEC_SIZE_F1_64    = 63;//6'b111111; // 63 bits representan la parte decimal
localparam DEC_SIZE_F1_32    = 31;//6'b011111; // 31 bits representan la parte decimal
localparam DEC_SIZE_F2_64    = 62;//6'b111110; // 62 bits representan la parte decimal
localparam DEC_SIZE_F2_32    = 30;//6'b011110; // 30 bits representan la parte decimal
localparam DEC_SIZE_F4_64    = 61;//6'b111101; // 61 bits representan la parte decimal
localparam DEC_SIZE_F4_32    = 29;//6'b011101; // 29 bits representan la parte decimal
localparam DEC_SIZE_F180_64  = 55;//6'b110111; // 55 bits representan la parte decimal
localparam DEC_SIZE_F180_32  = 23;//6'b010111; // 23 bits representan la parte decimal
// *****************************************************************************

