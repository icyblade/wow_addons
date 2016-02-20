--[[Bagnon Guild Bank Localization - Italian]]

local L = LibStub('AceLocale-3.0'):NewLocale('Bagnon-GuildBank', 'itIT')
if not L then return end

L.Title = "Banca di Gilda di %s"
L.Log1 = 'Resoconto transazioni.'
L.Log3 = 'Scheda informazioni.'
L.TipFunds = 'Fondi della Gilda'
L.TipDeposit = '<Clic Sinistro> per depositare.'
L.TipWithdrawRemaining = '<Clic Destro> per prelevare (%s rimanenti).'
L.TipWithdraw = '<Clic Destro> per prelevare (nessuna rimanenza).'


-- Automatically localized - do not translate!
L.Log2 = GUILD_BANK_MONEY_LOG
