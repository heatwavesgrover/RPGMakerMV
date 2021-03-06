#==============================================================================
# ■ スクリプト呼び出しアイテム
#  ItemCallScript.rb
#------------------------------------------------------------------------------
# 　
# 使用したときに任意のスクリプトを実行するアイテムもしくはスキルを作成できます。
# メニュー画面で使用した場合、コモンイベント呼び出しと異なりマップ画面に戻らずに
# その場で実行できます。
# 活用にはRGSSの知識が必要です。
#
# ●使い方
# 1.アイテムもしくはスキルのメモ欄に以下の通り指定してください。
# <=（実行したいスクリプト）=>
#
# 例（使用すると変数[1]に値[100]が設定されます）
# <=
# $game_variables[1] = 100
# =>
#
# 効果範囲を味方全体、敵全体にすると対象の全員分だけスクリプトが実行されます。
#
# スクリプト中では以下の変数、関数が使用できます。
# user     : アイテムの使用者
# target   : アイテムの対象
#
# ●利用規約
#  作者に無断で改変、再配布が可能で、利用形態（商用、18禁利用等）についても
#  制限はありません。
#  このスクリプトはもうあなたのものです。
#-----------------------------------------------------------------------------
# (C)2018 Triacontane
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
#-----------------------------------------------------------------------------
# Version
# 1.0.0 2018/09/20 初版
# ----------------------------------------------------------------------------
# [Blog]   : https://triacontane.blogspot.jp/
# [Twitter]: https://twitter.com/triacontane/
# [GitHub] : https://github.com/triacontane/
#=============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用
  #    行動側に対して呼び出され、使用対象以外に対する効果を適用する。
  #--------------------------------------------------------------------------
  alias ics_use_item use_item
  def use_item(item)
    ics_use_item(item)
    if !item.for_opponent? and !item.for_friend?
      apply_script_if_exist(self, item)
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの適用テスト
  #    使用対象が全快しているときの回復禁止などを判定する。
  #--------------------------------------------------------------------------
  alias ics_item_test item_test
  def item_test(user, item)
    return true if ics_item_test(user, item)
    get_item_script(item) != nil
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用者側への効果
  #--------------------------------------------------------------------------
  alias ics_item_user_effect item_user_effect
  def item_user_effect(user, item)
    ics_item_user_effect(user, item)
    apply_script_if_exist(user, item)
  end
  #--------------------------------------------------------------------------
  # ● スクリプトを取得します。
  #--------------------------------------------------------------------------
  def get_item_script(item)
    item.note.match(/<=(.*?)=>/m) {$1}
  end
  #--------------------------------------------------------------------------
  # ● スクリプトの指定があれば実行します。
  #--------------------------------------------------------------------------
  def apply_script_if_exist(user, item)
    script = get_item_script(item)
    if script != nil
      target = self
      eval(get_item_script(item))
    end
  end
end
