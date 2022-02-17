require 'gosu'

class GameEnded
  def initialize
    @button_font = Gosu::Font.new(35)
    @button_play_again = Game::fig["button_play_again"]
    @winner = nil
  end

  def checkwinner(p1,p2)
    if p1>p2
      @winner = "Player 1 Won"
    elsif p2>p1
      @winner = "Player 2 Won"
    else p1 == p2
      @winner = "It's Draw"
    end
  end

  def draw
    @button_font.draw(@winner,400,220,1)
  @button_play_again.draw(380, 270, 1)
  end

  def update
  end

  def button_down(id)
  end

  def button_up(id)
    if ($w.mouse_x > 380 && $w.mouse_x < 380+218 && $w.mouse_y > 270 && $w.mouse_y < 270+60)
        $current_room = PlayGame.new
    end
  end
end


class PlayGame

  POSITION = {
    0 => [2, 2, 1],
    1 => [150, 2, 1],
    2 => [300, 2, 1],
    3 => [450, 2, 1],
    4 => [600, 2, 1],
    5 => [2, 150, 1],
    6 => [150, 150, 1],
    7 => [300, 150, 1],
    8 => [450, 150, 1],
    9 => [600, 150, 1],
    10 => [2, 300, 1],
    11 => [150, 300, 1],
    12 => [300, 300, 1],
    13 => [450, 300, 1],
    14 => [600, 300, 1],
    15 => [2, 450, 1],
    16 => [150, 450, 1],
    17 => [300, 450, 1],
    18 => [450, 450, 1],
    19 => [600, 450, 1]
  }

  def initialize
    @font = Game::font["my_font"]
    @card_back = Game::fig["card_back"]
    @cards = []
    load_cards

    @current_time = 0; @start_time = Gosu::milliseconds/1000

    @last_clicked_card = nil
    @click = 0
    @first_card = nil
    @second_card = nil
    @player = 1
    @p1score = 0
    @p2score = 0
  end

  def changeplayer()
    if @player == 1
      @player = 2
    else
      @player = 1
    end
  end

  def updatescore()
    if @player == 1
      @p2score += 2
    elsif @player == 2
      @p1score += 2
    end
  end

  def draw
     @font.draw("Current Player: ", 780, 30, 1)
     @font.draw(@player, 900, 30, 1)
     @font.draw("Player 1 Score: ", 780,80,1)
     @font.draw(@p1score , 900,80,1)
     @font.draw("Player 2 Score: ", 780,130,1)
     @font.draw(@p2score , 900,130,1)


    0.upto(19) do |i|
      if !@cards[i]
        next
      elsif (@second_card == i) && @click.even?
        @cards[@second_card].draw(*POSITION[@second_card])
      elsif @first_card == i
        @cards[@first_card].draw(*POSITION[@first_card])
      else
        @card_back.draw(*POSITION[i])
      end
    end
  end

  def update
  end

  def button_down(id)
  end

  def button_up(id)
    if id == Gosu::MsLeft then
      POSITION.each do |k, arr|
        if $w.mouse_x > arr[0] && $w.mouse_x < arr[0]+150 && $w.mouse_y > arr[1] && $w.mouse_y < arr[1]+150 && @cards[k] != nil && @last_clicked_card != k
          @last_clicked_card = k
          if @last_clicked_card
            @click += 1
          end
          if @click.odd?
            @first_card = k
          else
            @second_card = k
            changeplayer()
          end
        end
      end
      if @first_card && @second_card && @click.even? && (@cards[@first_card] == @cards[@second_card]) && (@first_card != @second_card)
        @cards[@first_card] = nil
        @cards[@second_card] = nil
        @first_card = nil
        @second_card = nil
        updatescore()
      end
      if game_ended
        $current_room = GameEnded.new
        $current_room.checkwinner(@p1score,@p2score)
      end
    end
  end

  def load_cards
    2.times do
      1.upto(10) do |i|
        @cards << Game::fig[i]
      end
    end
    @cards = @cards.shuffle
  end

  def game_ended
    if @cards[0..19] == Array.new(20)
      return true
    end
  end

end


class Game < Gosu::Window

  SCREENWIDTH = 1000
  SCREENHEIGHT= 610

  def initialize
    super(SCREENWIDTH, SCREENHEIGHT, {:fullscreen => false})
    self.caption = "Memory Game"

    @@fig = {}
    @@font  = {}

    load_fig
    load_font

    $current_room = PlayGame.new
  end

  def draw
    $current_room.draw
  end

  def update
    $current_room.update
  end

  def button_down(id)
    if id == Gosu::KbEscape then
        $w.close
    end

    $current_room.button_down(id)
  end

  def button_up(id)
    $current_room.button_up(id)
  end

  def Game.fig
    @@fig
  end

  def Game.font
    @@font
  end

  def load_fig
    @@fig[1] = Gosu::Image.new("./Media/apple.jpg", {:retro => true})
    @@fig[2] = Gosu::Image.new("./Media/banana.jpg", {:retro => true})
    @@fig[3] = Gosu::Image.new("./Media/cherry.jpg", {:retro => true})
    @@fig[4] = Gosu::Image.new("./Media/kiwi.jpg", {:retro => true})
    @@fig[5] = Gosu::Image.new("./Media/lemon.jpg", {:retro => true})
    @@fig[6] = Gosu::Image.new("./Media/mango.jpg", {:retro => true})
    @@fig[7] = Gosu::Image.new("./Media/orange.jpg", {:retro => true})
    @@fig[8] = Gosu::Image.new("./Media/peach.jpg", {:retro => true})
    @@fig[9] = Gosu::Image.new("./Media/pear.jpg", {:retro => true})
    @@fig[10] = Gosu::Image.new("./Media/strawberry.jpg", {:retro => true})
    @@fig["card_back"] = Gosu::Image.new("./Media/que.jpg", {:retro => true})
    @@fig["button_play_again"] = Gosu::Image.new("./Media/new_game1.png", {:retro => true})
  end

  def load_font
    @@font["my_font"] = Gosu::Font.new(18, {:name => "Courier"})
  end

  def needs_cursor?
    true
  end

end

$w = Game.new
$w.show
