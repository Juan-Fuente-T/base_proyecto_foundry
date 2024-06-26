// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import "../src/EducatETH.sol"; // Asegúrate de que la ruta sea correcta según tu estructura de directorios

contract EducatETHTests is Test {
    EducatETH educatETH;
    address alice;
    address bob;
event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 amount
    );

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] amounts
    );

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    event URI(string value, uint256 indexed id);


    function setUp() public {
        alice = makeAddr("alice"); 
        bob = makeAddr("bob"); 
        startHoax(alice);
        // console.log("alice address", alice);
        educatETH = new EducatETH(alice);
    }

    function testInitialValues() public view{
        assertEq(educatETH.name(), "EducatETH NFT");
        assertEq(educatETH.symbol(), "EEN");
    }

    function testMint() public {
        uint256 tokenId = 1;
        educatETH.mint(alice, tokenId, 1);

        assertEq(educatETH.uri(tokenId), "https://ipfs.io/ipfs/QmSuQaSxg4kbmN8N6KwnNyvYNzDNiu7gx1AfNeeN384q5F");
    }

    function testMintBatch() public {
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1;
        amounts[1] = 1;

       
        educatETH.mintBatch(alice, ids, amounts);

        assertEq(educatETH.balanceOf(alice, 1), 2); //alice poseeria el que mintea ahora mas el mint inicial del que deploya el contrato
        assertEq(educatETH.balanceOf(alice, 2), 1);
    }

    // Continuación de EducatETHTests.sol

function testSafeTransferFrom() public {
    uint256 tokenId = 1;
    uint256 amount = 1;

    // Primero, mint un token al contrato de pruebas
    educatETH.mint(alice, tokenId, amount);
    // Verificamos que el balance de quien mintea sea 1
    assertEq(educatETH.balanceOf(alice, tokenId), amount + 1);
    // Verificamos que el balance del destinatario sea 0
    assertEq(educatETH.balanceOf(bob, tokenId), 0);

    // Luego, intentamos transferir ese token a otro contrato
    vm.expectEmit();
    emit TransferSingle(alice, alice, bob, tokenId, amount);
    educatETH.safeTransferFrom(alice, bob, tokenId, amount, "");

    // Verificamos que el balance del destinatario haya aumentado
    assertEq(educatETH.balanceOf(bob, tokenId), amount);
    // Verificamos que el balance del remitente haya disminuido
    assertEq(educatETH.balanceOf(alice, tokenId), 1);
}

function testSafeBatchTransferFrom() public {
    uint256[] memory ids = new uint256[](2);
    ids[0] = 1;
    ids[1] = 2;
    uint256[] memory amounts = new uint256[](2);
    amounts[0] = 1;
    amounts[1] = 1;

    // Primero, mint varios tokens al contrato de pruebas
    educatETH.mintBatch(alice, ids, amounts);

    // Luego, intentamos transferir esos tokens a otro contrato
    vm.expectEmit();
    emit TransferBatch(alice, alice, bob, ids, amounts);
    educatETH.safeBatchTransferFrom(alice, bob, ids, amounts, "");

    // Verificamos que el balance del destinatario haya aumentado para ambos tokens
    assertEq(educatETH.balanceOf(bob, 1), 1);
    assertEq(educatETH.balanceOf(bob, 2), 1);
    // Verificamos que el balance del remitente haya disminuido para ambos tokens
    assertEq(educatETH.balanceOf(alice, 1), 1);
    assertEq(educatETH.balanceOf(alice, 2), 0);
}

function testBalanceOfBatch() public {
    uint256[] memory ids = new uint256[](2);
    ids[0] = 1;
    ids[1] = 2;
            uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1;
        amounts[1] = 1;
        address[] memory addresses = new address[](2);
        addresses[0] = alice;
        addresses[1] = bob;

    // Asegúrate de que los arrays sean dinámicos y tengan el tipo correcto
    educatETH.mintBatch(bob, ids, amounts);

    uint256[] memory balances = educatETH.balanceOfBatch(addresses, ids);
    // Verificamos que el balance obtenido coincide con el esperado
    startHoax(bob);
    assertEq(balances[0], 1);
    assertEq(balances[1], 1);
}

function testSetApprovalForAll() public {
    vm.expectEmit();
    emit ApprovalForAll(alice, address(educatETH), true);
    educatETH.setApprovalForAll(address(educatETH), true);

    // Verificamos que la autorización ha sido establecida correctamente
    assertTrue(educatETH.isApprovedForAll(alice, address(educatETH)));
}

function testBatchBurn() public {
    // Simular los valores de ID y cantidad
    uint256[] memory ids = new uint256[](2);
    uint256[] memory amounts = new uint256[](2);
    ids[0] = 1;
    ids[1] = 2;
    amounts[0] = 5;
    amounts[1] = 3;

    educatETH.mintBatch(alice, ids, amounts);
    assertEq(educatETH.balanceOf(alice, ids[0]), 6);
    assertEq(educatETH.balanceOf(alice, ids[1]), 3);

    // Llamar a la función _batchBurn en el contrato
    educatETH.batchBurn(alice, ids, amounts);

    // Verificar que los balances se hayan actualizado correctamente
    assertEq(educatETH.balanceOf(alice, ids[0]), 1);
    assertEq(educatETH.balanceOf(alice, ids[1]), 0);
}

function testBurn() public {
    // Simular un ID y una cantidad
    
    uint256 id = 1;
    uint256 amount = 10;
    educatETH.mint(alice, id, amount);
    assertEq(educatETH.balanceOf(alice, id), 11);
    // Llamar a la función _burn en el contrato
    educatETH.burn(alice, id, amount);

    // Verificar que el balance se haya actualizado correctamente
    assertEq(educatETH.balanceOf(alice, id), 1);

    }
       
}


