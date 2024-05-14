constant.CHAIN_BRIDGE_CHAIN_ID_ETH = 1
constant.CHAIN_BRIDGE_CHAIN_ID_RINKEBY = 4
constant.CHAIN_BRIDGE_CHAIN_ID_BSC = 56
constant.CHAIN_BRIDGE_CHAIN_ID_TEST_BSC = 97
constant.CHAIN_BRIDGE_CHAIN_ID_APTOS_TEST = 2
constant.CHAIN_BRIDGE_CHAIN_ID_APTOS_DEVNET = 32
constant.CHAIN_BRIDGE_CHAIN_ID_CFX = 1030
constant.CHAIN_BRIDGE_CHAIN_ID_TEST_CFX = 71

constant.CHAIN_BRIDGE_CHAIN_ID_ZKSYNC = 324
constant.CHAIN_BRIDGE_CHAIN_ID_TEST_ZKSYNC = 280

constant.CHAIN_BRIDGE_CHAIN_ID_SAAKURU = 7225878
constant.CHAIN_BRIDGE_CHAIN_ID_SCROLL = 534352
constant.CHAIN_BRIDGE_CHAIN_ID_LINEA = 59144
constant.CHAIN_BRIDGE_CHAIN_ID_MANTA = 169
constant.CHAIN_BRIDGE_CHAIN_ID_SKALE = 2046399126
constant.CHAIN_BRIDGE_CHAIN_ID_MOONBEAM = 1284
constant.CHAIN_BRIDGE_CHAIN_ID_CRONOS = 25
constant.CHAIN_BRIDGE_CHAIN_ID_OP = 10
constant.CHAIN_BRIDGE_CHAIN_ID_NOVA = 42170


function constant.getNameByChain(chain)
    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_BSC or chain == constant.CHAIN_BRIDGE_CHAIN_ID_TEST_BSC then
        return "BSC"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_CFX or chain == constant.CHAIN_BRIDGE_CHAIN_ID_TEST_CFX then
        return "CFX"
    end
    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_ZKSYNC or chain == constant.CHAIN_BRIDGE_CHAIN_ID_TEST_ZKSYNC then
        return "ZKSYNC"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_SAAKURU then
        return "SAAKURU"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_SCROLL then
        return "SCROLL"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_LINEA then
        return "LINEA"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_MANTA then
        return "MANTA"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_SKALE then
        return "SKALE"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_MOONBEAM then
        return "MOONBEAM"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_CRONOS then
        return "CRONOS"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_OP then
        return "OP"
    end

    if chain == constant.CHAIN_BRIDGE_CHAIN_ID_NOVA then
        return "NOVA"
    end

    if chain == 0 then
        return "NONE"
    end
    return "UNKNOW"
end

constant.CHAIN_ICON_NAME = {
    ["BSC"] = "Common_Atlas[BSC_icon]",
    ["CFX"] = "Common_Atlas[Confulx_icon]",
    ["ZKSYNC"] = "Common_Atlas[ZK_icon]",
    ["SAAKURU"] = "Common_Atlas[SAAKURU_icon]",
    ["SCROLL"] = "Common_Atlas[SCROLL_icon]",
    ["LINEA"] = "Common_Atlas[LINEA_icon]",
    ["MANTA"] = "Common_Atlas[MANTA_icon]",
    ["SKALE"] = "Common_Atlas[SKALE_icon]",
    ["MOONBEAM"] = "Common_Atlas[MOONBEAM_icon]",
    ["CRONOS"] = "Common_Atlas[CRONOS_icon]",
    ["OP"] = "Common_Atlas[OP_icon]",
    ["NOVA"] = "Common_Atlas[NOVA_icon]",
}

constant.CHAIN_BRANCH_KEY = {
    ["alpha"] = "alphaChainId",
    ["beta"] = "betaChainId",
    ["release"] = "releaseChainId",
    ["local"] = "alphaChainId",
}
constant.CHAIN_NFT_KIND_SPACESHIP = 1          --""
constant.CHAIN_NFT_KIND_HERO = 2               --""
constant.CHAIN_NFT_KIND_DEFENSIVE = 3          --""