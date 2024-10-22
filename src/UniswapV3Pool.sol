pragma solidity ^0.8.14;

contract UniswapV3Pool{
    using Tick for mapping(int24 => Tick.info);
    using Position for mapping(bytes32=> Position.info);
    using Position for Position.Info;

    int24 internal constant MIN_TICK = -887272;
    int24 internal constant MAX_TICK = -MIN_TICK;

    // pool tokens, immutable
    address public immutable token0;
    address public immutable token1;

    // packing variables that are read together
    struct Slot0{
        // current sqrt(P)
        uint160 sqrtPriceX96;
        // current tick
        int24 tick;

    }

    Slot0 public slot0;

    // amount of liquidity, L
    uint128 public liquidity;

    // ticks info
    mapping(int24 => Tick.Info) public ticks;
    // positions info
    mapping(bytes32 => Position.Info) public positions;

    event Mint(
        address indexed sender,
        address indexed owner,
        int24 lowerTick,
        int24 upperTick,
        uint256 amount,
        uint256 amount0,
        uint256 amount1
    );

    constructor(
        address token0_,
        address token1_,
        uint160 sqrtPriceX96,
        int24 tick
    ){
        token0 = token0_;
        token1 = token1_;

        slot0 = Slot0({sqrtPriceX96: sqrtPriceX96, tick: tick});

    }

    function mint(
        address owner,
        int24 lowerTick,
        int24 upperTick,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1){
        // this mint function will take
        // owner address to track owner of liquidity
        // upper and lower tick to set the bounds of the price range
        // the amount of liquidity we are willing to provide

        // how minting works or will work:
        // the user specifies price range and liquidity amount
        // the contract updates the ticks and positions mappings
        // the contract calculates token amounts the user must send
        // the contract takes tokens from the user and verifies the correct amounts were set

        if(
            lowerTick >= upperTick || 
            lowerTick < MIN_TICK ||
            upperTick > MAX_TICK
        ) revert InvalidTickRange();

        if (amount == 0) revert ZeroLiquidity();

        ticks.update(lowerTick, amount);
        ticks.update(upperTick, amount);

        Position.Info storage Position = positions.get(
            owner,
            lowerTick,
            upperTick
        );
        position.update(amount);

        amount0 = 0.998976618347425280 ether;
        amount1 = 5000 ether;

        liquidity += uint128(amount);

        uint256 balance0Before;
        uint256 balance1Before;
        if(amount > 0) balance0Before = balance0();
        if(amount > 0) balance1Before = balance1();

        IUniswapV3MintCallbak(msg.sender).uniswapV3MintCallback(
            amount0,
            amount1
        );
        if(amount0 > 0 && balance0Before + amount0 > balance0())
            revert InsufficientInputAmount();
        if(amount1 > 0 && balance1Before + amount1 > balance1())
            revert InsufficientInputAmount();
    }

    function balance0() internal returns (uint256 balance){
        balance = IERC20(token0).balanceOf(address(this));
    }
    function balance1() internal returns (uint256 balance){
        balance = IERC20(token1).balanceOf(address(this));
    }
    
    // emit Mint(msg.sender, owner, lowerTick, upperTick, amount, amount0, amount1);
}