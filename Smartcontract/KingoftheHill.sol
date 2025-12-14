// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
                                                                                                    
                                                                                                    
                                                 --                                                 
                                         ..::::.-@@-.::::..                                         
                                   ..::=#@@@@*#*@@@@*%*@%@@#=::..                                   
                                ..-%@%%+%@@@%##@@@@@@##%@@@%*%%@%-..                                
                             .:*@#@*@@*=*@@@#%@@@%%@@@%#@@@*=*%@*@#@*..                             
                           .+@@=@@+=@@@@@@@*#@@=@@@@-@@%*@@@@@@@=+@@=@@+..                          
                         :*%#%@=#@@@@@#@@@**@@#@@@@@@%@@#*@@@#@@@@@#=@@#%*.                         
                       :+@+#%*%@@@@@@@%*@**@@@@**@@+#@@@@**@*#@@@@@@@%+%#+@*:                       
                     .=@%%%#@@@@@+@@@@@#=*@@@@@#@@@@*@@@@@#-*@@@@@*@@@@%*#%%@=.                     
                    :*@@%#%@@@@@@@*%@@@##@@@@##@@@@@@#%@@@@##@@@%*@@@@@@@%#%@@*:                    
                  .:%@@#*@@@#@@@@@@*=@#%@@@@##@@@@@@@@##@@@@%#@=*@@@@@@%@@@*#@@%:.                  
                  :@%%##@@@@@@*----+@@%@@@@@@@@@@@@@@@@@@@@@@%@@*----+@@@@@@##%%%-.                 
                 :@%%#%@@@@%-...:-...-#@@%+-::........::-+%@@#-...-:...-%@@@@%#%%@:                 
                .%@%##@@@@#:.=%@@@@%=..-..                ..-..=%@@@@%-.:#@@@@##%@%.                
               .#@%%*@@@@@=.-%@@@@@%-.          .....         .=%@@@@@%:.=@@@@@*%%@*                
               -@#@+@@@@@@= -%@@@%-.       .-+#@@@@@@#+-.       .-%@@@%: -@@@@@@+@#@-               
              .%%%#%@@@%%@#:.=%@-.       .=%@@%*+==+*%@@%=.       .=@%-.:#@%%@@@%##%%.              
              -@*@=@@@@@@@@#-....     ..:#@@@#========#@@@#-.       ...-#@@@@@@@@+@*@:              
              +%#%*@@@@@@@@@@+.        :*@@@@*========+@@@@*:  .     .+@@@@@@@@@@+%*%=              
              #%%#%@@%%##**%#:         .:#@@@#+======+#@@@#:.       . :#%**##%%@@%##%*              
             .#%%*@@@@@@@@@@-.  .=+:.    .-#@@%*++++*%@@#-.    .:+=.  .-@@@@@@@@@%#%%#              
              #%%*@@@@@@@@@+. .=@@@@#=.. . .:+#%@@@@%#+:.    .=#@@@@=...+@@@@@@@@%#%%#.             
              *%%#%@@%##*#%= .=@@@##%@%+:.      ....      .:+%@%#*@@@=. -%#*#%%@@#%%%*              
              =%#@+@@@@@##%- .%@@*===+%@@*:.   .        .:*@@%*===+@@@. -%##@@@@@+@*%-              
              :%+@+@@@@##@%- .%@@======+#@@#-..      ..-#@@#+======@@@: -%@##@@@@*@+@:              
              .*##%#@@##@@@- .#@@#========*@@%:    . :@@@*========*@@%. -@@@#*@@*%*%*               
               :@+@*%##@@@@=. :%@@#+======+%@#:  .. .:#@%*======+#@@@: .=@@@@%#%*@*@:               
                =@+%-%@@@@@%-. .#@@@@#**#@@@+. .-@@=. .+@@@%**#%@@@#. .:%@@@@@%-%*@=                
                .#%=@@@@@##@@-.. .+%@@@@@%=.  .#@@@@%.  .=#@@@@@%+. ..-@@#*@@@@@+@*                 
                 .=@@@@@##@@@@%-...           +@@@@@@*           ...-%@@@@#*@@@@@=.                 
                 -@@@@%**@@@@@@@@@%+-:..                    ..:-+%@@@@@@@@@**%@@@@-                 
               .=@@#*@@@**@@@@@@@@@@@@@*.   ...  ..  ...    *@@@@@@@@@@@@@#*@@@*#@@=                
               =@@@+@@@@%=-----------=%#.  .*@+-*@@#-=@#.  .*%+-----------+%@@@@*@@@=               
              *@@@@@=%@#*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*#@%+%@@@@*.             
            .#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#.            
           ..-------------:+#=+#+-#########**###########*#########-*#+=#+:-------------..           
                           .:+@#@#@#=#@@@@@@@@@@@@@@@@@@@@@@@@#+#@%@#@+:.                           
                              .:+%@*@#@%#++#@@@@@@@@@@@@#++#%%%@*@%+:.                              
                                 .:-+%@%%#%#%%%%%%%%%%%%###%%@%+-:.                                 
                                    ..:--=+#%%@%@%@@%@%%*+=--:..                                    
                                           ....::::::...                                            
                                                                                                    
                                                                                                    
                        ++++  ++++                                                          
  ++++++++      +++++++ ++++  ++++  ++++++ ++++++++++++++++++                             
++++++++++    ++++++++  ++++  ++++  ++++++ +++++++++++++++++  +++++++++                   
++++++++++  ++++++++++  ++++  ++++  ++++++ +++++++++++++++  ++++++++++++++                
++++++++   +++++++      ++++++++++  ++++++       ++++++++ +++++++++++++++++               
 +++++++++ +++++++      ++++++++++  ++++++      ++++++++  ++++++     +++++++              
   +++++++++++++++      ++++  ++++  ++++++     ++++++++  +++++++      ++++++              
     +++++++++++++++++  ++++  ++++  ++++++    ++++++++   +++++++     +++++++              
++++++++++++ +++++++++  ++++  ++++  ++++++   ++++++++++++ +++++++++++++++++               
+++++++++++     +++++++ ++++  ++++  ++++++ +++++++++++++   +++++++++++++++                
+++++++++               ++++  ++++        +++++++++++++       ++++++++++                  
                                                                                          
                                                                                          
  ++++++++++ +++      +++ +++++++++    ++++++++++++ +++            ++++++++++
+++++        +++     ++++ ++++   +++++ ++++++++++++ +++          +++++ 
++++++++++++ ++++++++++++ +++++++++++      +++      +++          +++++++++++ 
++++++++++++   ++++++++   +++++++++        +++      +++          ++++++++++++
        ++++     ++++     +++     ++++     +++      +++                  ++++
        ++++     ++++     ++++++++++++ ++++++++     +++++++++++          ++++
 ++++++++++      ++++     ++++++++++   ++++++++++++ ++++++++++++ ++++++++++                                                                                    

*/

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// ========== Custom Errors ==========
error RoundAlreadyActive();
error RoundNotActive();
error RoundNotOver();
error RoundEnded();
error MaxNFTsStaked();
error NotNFTOwner();
error MustSendETH();
error InsufficientETHForJackpot();
error NoFundsToWithdraw();
error WithdrawalFailed();

contract SchizoOfTheHill is Ownable, ReentrancyGuard, IERC721Receiver {

    // ========== Core State ==========
    uint256 public jackpot;
    uint256 public survivorJackpot;
    IERC721 public nftContract;
    uint256 public currentRound;
    uint256 public roundStartTime;
    uint256 public constant ROUND_DURATION = 24 hours;
    uint256 public constant MAX_NFTS_PER_ROUND = 100;
    bool public isRoundActive;
    address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    // NFT Tracking
    uint256[] private stakedTokenIds;
    mapping(uint256 => address) private tokenIdToOwner;
    mapping(address => uint256[]) private ownerToTokenIds;

    // Survivor Tracking - tracks how many rounds each NFT has survived
    mapping(uint256 => uint256) public survivedRounds;
    mapping(uint256 => address) public lastKnownHolder;
    uint256 public mostSurvivedTokenId;
    uint256 public mostSurvivedRoundsCount;
    
    // Round Participation Tracking - tracks which rounds each NFT participated in and survived
    mapping(uint256 => uint256[]) public participatedRounds; // Rounds this NFT participated in
    mapping(uint256 => uint256[]) public survivedRoundsList;   // Rounds this NFT survived
    
    // Track all NFTs that have ever participated (for leaderboard queries)
    uint256[] private allParticipatedTokenIds;
    mapping(uint256 => bool) private hasParticipated;

    // Burned NFT Tracking
    uint256[] private burnedTokenIds;
    mapping(uint256 => bool) public isBurned;

    // Pull-over-Push: Track pending withdrawals for failed transfers
    mapping(address => uint256) public pendingWithdrawals;

    // ========== Events ==========
    event RoundStarted(address indexed starter, uint256 indexed round, uint256 startTime, uint256 endTime);
    event NFTStaked(address indexed staker, uint256 tokenId);
    event NFTBurned(uint256 tokenId);
    event JackpotWon(address indexed winner, uint256 amount);
    event SurvivorJackpotWon(address indexed winner, uint256 tokenId, uint256 survivedRounds, uint256 amount);
    event NFTReturned(address indexed owner, uint256 tokenId);
    event NFTSurvived(uint256 tokenId, uint256 totalSurvivedRounds);
    event WithdrawalPending(address indexed recipient, uint256 amount);
    event FundsWithdrawn(address indexed recipient, uint256 amount);
    event JackpotFunded(address indexed funder, uint256 amount, uint256 newTotal);
    event SurvivorJackpotFunded(address indexed funder, uint256 amount, uint256 newTotal);

    constructor(address _nftContract, uint256 _initialJackpot) payable Ownable(msg.sender) {
        if (msg.value < _initialJackpot) revert InsufficientETHForJackpot();

        nftContract = IERC721(_nftContract);
        jackpot = msg.value;
    }

    // ========== Round Management ==========
    function startRound() external nonReentrant {
        if (isRoundActive) revert RoundAlreadyActive();
        if (block.timestamp < roundStartTime + ROUND_DURATION && roundStartTime != 0) revert RoundNotOver();

        currentRound++;
        isRoundActive = true;
        roundStartTime = block.timestamp;
        emit RoundStarted(msg.sender, currentRound, roundStartTime, roundStartTime + ROUND_DURATION);
    }

    function stakeNFT(uint256 tokenId) external nonReentrant {
        if (!isRoundActive) revert RoundNotActive();
        if (block.timestamp >= roundStartTime + ROUND_DURATION) revert RoundEnded();
        if (stakedTokenIds.length >= MAX_NFTS_PER_ROUND) revert MaxNFTsStaked();
        if (nftContract.ownerOf(tokenId) != msg.sender) revert NotNFTOwner();

        nftContract.safeTransferFrom(msg.sender, address(this), tokenId);
        stakedTokenIds.push(tokenId);
        tokenIdToOwner[tokenId] = msg.sender;
        ownerToTokenIds[msg.sender].push(tokenId);
        
        // Track last known holder for survivor jackpot
        lastKnownHolder[tokenId] = msg.sender;
        
        // Track participation in this round
        participatedRounds[tokenId].push(currentRound);
        
        // Track this NFT as having participated (for leaderboard queries)
        if (!hasParticipated[tokenId]) {
            hasParticipated[tokenId] = true;
            allParticipatedTokenIds.push(tokenId);
        }
        
        emit NFTStaked(msg.sender, tokenId);
    }

    function endRound() external nonReentrant {
        if (!isRoundActive) revert RoundNotActive();
        if (block.timestamp < roundStartTime + ROUND_DURATION) revert RoundNotOver();

        isRoundActive = false;
        uint256 totalStaked = stakedTokenIds.length;

        if (totalStaked == 0) {
            return; // No NFTs staked
        } else if (totalStaked == 1) {
            _handleSingleNFTRound();
        } else {
            _handleMultiNFTRound(totalStaked);
        }
    }

    /// @dev Handle round ending with a single NFT (winner takes all)
    function _handleSingleNFTRound() private {
        uint256 tokenId = stakedTokenIds[0];
        address winner = tokenIdToOwner[tokenId];
        
        // ===== EFFECTS (State Changes First) =====
        // Increment survived rounds for the winning NFT
        survivedRounds[tokenId]++;
        survivedRoundsList[tokenId].push(currentRound);
        emit NFTSurvived(tokenId, survivedRounds[tokenId]);
        
        // Update most survived tracking if this NFT beats the record
        if (survivedRounds[tokenId] > mostSurvivedRoundsCount) {
            mostSurvivedRoundsCount = survivedRounds[tokenId];
            mostSurvivedTokenId = tokenId;
        }
        
        // Calculate prizes before clearing state
        uint256 prize = jackpot;
        jackpot = 0;
        
        uint256 survivorPrize = 0;
        address survivorWinner = address(0);
        if (survivorJackpot > 0 && mostSurvivedRoundsCount > 0) {
            survivorWinner = lastKnownHolder[mostSurvivedTokenId];
            survivorPrize = survivorJackpot;
            survivorJackpot = 0;
        }
        
        // Clean up mappings
        _removeTokenFromOwner(winner, tokenId);
        delete tokenIdToOwner[tokenId];
        delete stakedTokenIds;

        // ===== INTERACTIONS (External Calls Last) =====
        // Pay main jackpot
        _safeTransferETH(winner, prize);
        emit JackpotWon(winner, prize);
        
        // Pay survivor jackpot
        if (survivorPrize > 0) {
            _safeTransferETH(survivorWinner, survivorPrize);
            emit SurvivorJackpotWon(survivorWinner, mostSurvivedTokenId, mostSurvivedRoundsCount, survivorPrize);
        }

        // Return the NFT
        nftContract.safeTransferFrom(address(this), winner, tokenId);
        emit NFTReturned(winner, tokenId);
    }

    /// @dev Handle round ending with multiple NFTs (burn one, return survivors)
    function _handleMultiNFTRound(uint256 totalStaked) private {
        uint256 burnCount = 1;
        uint256 survivorCount = totalStaked - burnCount;
        
        // Create memory arrays to store results
        uint256[] memory tokensToBurn = new uint256[](burnCount);
        address[] memory burnedOwners = new address[](burnCount);
        uint256[] memory tokensToReturn = new uint256[](survivorCount);
        address[] memory ownersToReturn = new address[](survivorCount);

        // Copy array to memory for manipulation (Fisher-Yates shuffle variant)
        uint256[] memory tempTokenIds = new uint256[](totalStaked);
        for (uint256 i = 0; i < totalStaked; i++) {
            tempTokenIds[i] = stakedTokenIds[i];
        }

        // Select random tokens to burn
        for (uint256 i = 0; i < burnCount; i++) {
            uint256 randomIndex = uint256(
                keccak256(abi.encodePacked(block.timestamp, block.prevrandao, i))
            ) % (totalStaked - i);

            tokensToBurn[i] = tempTokenIds[randomIndex];
            burnedOwners[i] = tokenIdToOwner[tempTokenIds[randomIndex]];
            // Swap with last unprocessed element
            tempTokenIds[randomIndex] = tempTokenIds[totalStaked - 1 - i];
        }

        // Remaining tokens are survivors (first survivorCount elements after shuffle)
        for (uint256 i = 0; i < survivorCount; i++) {
            tokensToReturn[i] = tempTokenIds[i];
            ownersToReturn[i] = tokenIdToOwner[tempTokenIds[i]];
        }

        // ===== EFFECTS (State Changes First) =====
        // Update survival stats for survivors
        for (uint256 i = 0; i < survivorCount; i++) {
            uint256 tokenId = tokensToReturn[i];
            survivedRounds[tokenId]++;
            survivedRoundsList[tokenId].push(currentRound);
            emit NFTSurvived(tokenId, survivedRounds[tokenId]);
            
            if (survivedRounds[tokenId] > mostSurvivedRoundsCount) {
                mostSurvivedRoundsCount = survivedRounds[tokenId];
                mostSurvivedTokenId = tokenId;
            }
        }

        // Clean up mappings for burned tokens
        for (uint256 i = 0; i < burnCount; i++) {
            uint256 tokenId = tokensToBurn[i];
            address owner = burnedOwners[i];
            _removeTokenFromOwner(owner, tokenId);
            delete tokenIdToOwner[tokenId];
        }
        
        // Clean up mappings for returned tokens
        for (uint256 i = 0; i < survivorCount; i++) {
            uint256 tokenId = tokensToReturn[i];
            address owner = ownersToReturn[i];
            _removeTokenFromOwner(owner, tokenId);
            delete tokenIdToOwner[tokenId];
        }
        
        // Clear staked tokens array
        delete stakedTokenIds;

        // ===== INTERACTIONS (External Calls Last) =====
        // Burn selected NFTs and track them
        for (uint256 i = 0; i < burnCount; i++) {
            uint256 tokenId = tokensToBurn[i];
            burnedTokenIds.push(tokenId);
            isBurned[tokenId] = true;
            nftContract.safeTransferFrom(address(this), BURN_ADDRESS, tokenId);
            emit NFTBurned(tokenId);
        }

        // Return surviving NFTs
        for (uint256 i = 0; i < survivorCount; i++) {
            nftContract.safeTransferFrom(address(this), ownersToReturn[i], tokensToReturn[i]);
            emit NFTReturned(ownersToReturn[i], tokensToReturn[i]);
        }
    }

    // ========== Pull-over-Push Withdrawal ==========
    /// @notice Withdraw any pending funds from failed transfers
    function withdrawFunds() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        if (amount == 0) revert NoFundsToWithdraw();
        
        // Clear pending amount before transfer (CEI pattern)
        pendingWithdrawals[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            // Restore the pending amount if transfer still fails
            pendingWithdrawals[msg.sender] = amount;
            revert WithdrawalFailed();
        }
        
        emit FundsWithdrawn(msg.sender, amount);
    }

    /// @dev Safely transfer ETH, storing in pendingWithdrawals if transfer fails
    function _safeTransferETH(address recipient, uint256 amount) private {
        if (amount == 0) return;
        
        (bool success, ) = payable(recipient).call{value: amount}("");
        if (!success) {
            pendingWithdrawals[recipient] += amount;
            emit WithdrawalPending(recipient, amount);
        }
    }

    /// @dev Remove a token from the owner's token list
    function _removeTokenFromOwner(address owner, uint256 tokenId) private {
        uint256[] storage tokens = ownerToTokenIds[owner];
        uint256 length = tokens.length;
        
        for (uint256 i = 0; i < length; i++) {
            if (tokens[i] == tokenId) {
                // Swap with last element and pop
                tokens[i] = tokens[length - 1];
                tokens.pop();
                break;
            }
        }
    }

    // ========== View Functions ==========
    function getRoundInfo()
        external
        view
        returns (
            bool active,
            uint256 round,
            uint256 endTime,
            uint256 stakedCount,
            uint256 currentJackpot,
            uint256 currentSurvivorJackpot
        )
    {
        return (
            isRoundActive,
            currentRound,
            roundStartTime + ROUND_DURATION,
            stakedTokenIds.length,
            jackpot,
            survivorJackpot
        );
    }

    function getStakerNFTs(address staker)
        external
        view
        returns (uint256[] memory)
    {
        return ownerToTokenIds[staker];
    }

    function getStakedNFTs()
        external
        view
        returns (uint256[] memory)
    {
        return stakedTokenIds;
    }

    /// @notice Get the survival stats for a specific NFT
    /// @param tokenId The token ID to query
    /// @return rounds Number of rounds this NFT has survived
    /// @return holder Last known holder of this NFT
    function getNFTSurvivalStats(uint256 tokenId)
        external
        view
        returns (uint256 rounds, address holder)
    {
        return (survivedRounds[tokenId], lastKnownHolder[tokenId]);
    }

    /// @notice Get the current survivor champion (NFT with most survived rounds)
    /// @return tokenId The token ID of the champion NFT
    /// @return rounds Number of rounds the champion has survived
    /// @return holder Last known holder of the champion NFT
    function getSurvivorChampion()
        external
        view
        returns (uint256 tokenId, uint256 rounds, address holder)
    {
        return (mostSurvivedTokenId, mostSurvivedRoundsCount, lastKnownHolder[mostSurvivedTokenId]);
    }

    /// @notice Get all burned NFT token IDs
    /// @return Array of token IDs that have been burned
    function getBurnedNFTs() external view returns (uint256[] memory) {
        return burnedTokenIds;
    }

    /// @notice Get the total count of burned NFTs
    /// @return Total number of NFTs that have been burned
    function getBurnedNFTCount() external view returns (uint256) {
        return burnedTokenIds.length;
    }

    /// @notice Check if a specific NFT has been burned
    /// @param tokenId The token ID to check
    /// @return True if the NFT has been burned, false otherwise
    function isNFTBurned(uint256 tokenId) external view returns (bool) {
        return isBurned[tokenId];
    }

    /// @notice Get pending withdrawal amount for an address
    /// @param account The address to check
    /// @return The amount of ETH pending withdrawal
    function getPendingWithdrawal(address account) external view returns (uint256) {
        return pendingWithdrawals[account];
    }

    /// @notice Get all rounds that an NFT participated in
    /// @param tokenId The token ID to query
    /// @return Array of round numbers this NFT participated in
    function getParticipatedRounds(uint256 tokenId) external view returns (uint256[] memory) {
        return participatedRounds[tokenId];
    }

    /// @notice Get all rounds that an NFT survived
    /// @param tokenId The token ID to query
    /// @return Array of round numbers this NFT survived
    function getSurvivedRounds(uint256 tokenId) external view returns (uint256[] memory) {
        return survivedRoundsList[tokenId];
    }

    /// @notice Get top NFTs by survived rounds (up to 10)
    /// @dev This function scans all NFTs that have ever participated and returns top 10 by survived rounds
    /// @return tokenIds Array of token IDs sorted by survived rounds (descending)
    /// @return rounds Array of survived round counts corresponding to each token ID
    /// @return holders Array of last known holders corresponding to each token ID
    function getTopNFTsBySurvivedRounds() external view returns (
        uint256[] memory tokenIds,
        uint256[] memory rounds,
        address[] memory holders
    ) {
        uint256 totalParticipated = allParticipatedTokenIds.length;
        
        // If no NFTs have participated, return empty arrays
        if (totalParticipated == 0) {
            return (new uint256[](0), new uint256[](0), new address[](0));
        }
        
        // Create arrays for sorting (only include NFTs that have survived at least one round)
        uint256[] memory tempTokenIds = new uint256[](totalParticipated);
        uint256[] memory tempRounds = new uint256[](totalParticipated);
        address[] memory tempHolders = new address[](totalParticipated);
        uint256 validCount = 0;
        
        // Populate arrays with NFTs that have survived at least one round
        for (uint256 i = 0; i < totalParticipated; i++) {
            uint256 tokenId = allParticipatedTokenIds[i];
            uint256 roundsSurvived = survivedRounds[tokenId];
            
            // Only include NFTs that have survived at least one round
            if (roundsSurvived > 0) {
                tempTokenIds[validCount] = tokenId;
                tempRounds[validCount] = roundsSurvived;
                tempHolders[validCount] = lastKnownHolder[tokenId];
                validCount++;
            }
        }
        
        // If no NFTs have survived any rounds, return empty arrays
        if (validCount == 0) {
            return (new uint256[](0), new uint256[](0), new address[](0));
        }
        
        // Simple bubble sort (for small arrays, gas efficient)
        // Only sort the valid entries
        for (uint256 i = 0; i < validCount; i++) {
            for (uint256 j = 0; j < validCount - i - 1; j++) {
                if (tempRounds[j] < tempRounds[j + 1]) {
                    // Swap rounds
                    uint256 tempRound = tempRounds[j];
                    tempRounds[j] = tempRounds[j + 1];
                    tempRounds[j + 1] = tempRound;
                    
                    // Swap token IDs
                    uint256 tempTokenId = tempTokenIds[j];
                    tempTokenIds[j] = tempTokenIds[j + 1];
                    tempTokenIds[j + 1] = tempTokenId;
                    
                    // Swap holders
                    address tempHolder = tempHolders[j];
                    tempHolders[j] = tempHolders[j + 1];
                    tempHolders[j + 1] = tempHolder;
                }
            }
        }
        
        // Return top 10 (or less if fewer NFTs exist)
        uint256 returnCount = validCount > 10 ? 10 : validCount;
        tokenIds = new uint256[](returnCount);
        rounds = new uint256[](returnCount);
        holders = new address[](returnCount);
        
        for (uint256 i = 0; i < returnCount; i++) {
            tokenIds[i] = tempTokenIds[i];
            rounds[i] = tempRounds[i];
            holders[i] = tempHolders[i];
        }
    }

    // ========== Funding Functions ==========
    /// @notice Add ETH to the main jackpot
    function fundJackpot() external payable {
        if (msg.value == 0) revert MustSendETH();
        jackpot += msg.value;
        emit JackpotFunded(msg.sender, msg.value, jackpot);
    }

    /// @notice Add ETH to the survivor jackpot
    function fundSurvivorJackpot() external payable {
        if (msg.value == 0) revert MustSendETH();
        survivorJackpot += msg.value;
        emit SurvivorJackpotFunded(msg.sender, msg.value, survivorJackpot);
    }

    /// @notice Receive ETH and add to main jackpot
    receive() external payable {
        jackpot += msg.value;
        emit JackpotFunded(msg.sender, msg.value, jackpot);
    }

    // ========== Admin Functions ==========
    function recoverStuckETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // ========== ERC721Receiver ==========
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
