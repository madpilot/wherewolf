require 'helper'

class ParserTest < Test::Unit::TestCase
  context 'Parser' do
    setup do
      @parser = Wherewolf::Parser.new
    end

    context "operands" do
       should 'parse [op1]=[literal]' do
        result = @parser.parse('name=Myles')
        assert_equal( { :eq => { :left => "name", :right => { :string => "Myles" } } }, result)
      end
      should 'parse [op1]="[string]"' do
        result = @parser.parse('name="Myles Eftos"') 
        assert_equal( { :eq => { :left => "name", :right => { :string => "Myles Eftos" } } }, result)
      end
      should 'parse [op1]=null' do
        result = @parser.parse('name=null') 
        assert_equal( { :eq => { :left => "name", :right => { :nil => "null" } } }, result)
      end
      should 'parse [op1]=true' do
        result = @parser.parse('active=true') 
        assert_equal( { :eq => { :left => "active", :right => { :boolean => "true" } } }, result)
      end
      should 'parse [op1]=false' do
        result = @parser.parse('active=false') 
        assert_equal( { :eq => { :left => "active", :right => { :boolean => "false" } } }, result)
      end
      should 'parse [op1]=[integer]' do
        result = @parser.parse('count=10') 
        assert_equal( { :eq => { :left => "count", :right => { :number => "10" } } }, result)
      end
      should 'parse [op1]=[float]' do
        result = @parser.parse('count=-10.3') 
        assert_equal( { :eq => { :left => "count", :right => { :number => "-10.3" } } }, result)
      end
    end

    context "comparators" do
      context "equals" do
        should 'parse [op1]=[op2]' do
          result = @parser.parse('name="Myles"')
          assert_equal( { :eq => { :left => "name", :right => { :string => "Myles" } } }, result)
        end
        should 'parse [op1] =[op2]' do
          result = @parser.parse('name ="Myles"') 
          assert_equal( { :eq => { :left => "name", :right => { :string => "Myles" } } }, result)
        end
        should 'parse [op1]= [op2]' do
          result = @parser.parse('name= "Myles"') 
          assert_equal( { :eq => { :left => "name", :right => { :string => "Myles" } } }, result)
        end
        should 'parse [op1] = [op2]' do
          result = @parser.parse('name = "Myles"') 
          assert_equal( { :eq => { :left => "name", :right => { :string => "Myles" } } }, result)
        end
      end
    
      context "not equals" do
        should 'parse [op1]!=[op2]' do
          result = @parser.parse('name!="Myles Eftos"') 
          assert_equal( { :not_eq => { :left => "name", :right => { :string => 'Myles Eftos' } } }, result)
        end
        should 'parse [op1] !=[op2]' do
          result = @parser.parse('name !="Myles Eftos"') 
          assert_equal( { :not_eq => { :left => "name", :right => { :string => 'Myles Eftos' } } }, result)
        end
        should 'parse [op1]!= [op2]' do
          result = @parser.parse('name!= "Myles Eftos"') 
          assert_equal( { :not_eq => { :left => "name", :right => { :string => 'Myles Eftos' } } }, result)
        end
        should 'parse [op1] != [op2]' do
          result = @parser.parse('name != "Myles Eftos"') 
          assert_equal( { :not_eq => { :left => "name", :right => { :string => 'Myles Eftos' } } }, result)
        end
      end

      context "less than" do
        should 'parse [op1]<[op2]' do
          result = @parser.parse("size<12") 
          assert_equal( { :lt => { :left => "size", :right => { :number => "12" } } }, result)
        end
        should 'parse [op1] <[op2]' do
          result = @parser.parse("size <12") 
          assert_equal( { :lt => { :left => "size", :right => { :number => "12" } } }, result)
        end
        should 'parse [op1]< [op2]' do
          result = @parser.parse("size< 12") 
          assert_equal( { :lt => { :left => "size", :right => { :number => "12" } } }, result)
        end
        should 'parse [op1] < [op2]' do
          result = @parser.parse("size < 12") 
          assert_equal( { :lt => { :left => "size", :right => { :number => "12" } } }, result)
        end
      end

      context "less than or equal to" do
        should 'parse [op1]<=[op2]' do
          result = @parser.parse("size<=12") 
          assert_equal( { :lteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1] <=[op2]' do
          result = @parser.parse("size <=12") 
          assert_equal( { :lteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1]<= [op2]' do
          result = @parser.parse("size<= 12") 
          assert_equal( { :lteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1] <= [op2]' do
          result = @parser.parse("size <= 12") 
          assert_equal( { :lteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
      end

      context "greater than" do
        should 'parse [op1]>[op2]' do
          result = @parser.parse("size>12") 
          assert_equal( { :gt => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1] >[op2]' do
          result = @parser.parse("size >12") 
          assert_equal( { :gt => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1]> [op2]' do
          result = @parser.parse("size> 12") 
          assert_equal( { :gt => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1] > [op2]' do
          result = @parser.parse("size > 12") 
          assert_equal( { :gt => { :left => "size", :right => { :number => '12' } } }, result)
        end
      end

      context "greater than or equal to" do
        should 'parse [op1]>=[op2]' do
          result = @parser.parse("size>=12") 
          assert_equal( { :gteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1] >=[op2]' do
          result = @parser.parse("size >=12") 
          assert_equal( { :gteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1]>= [op2]' do
          result = @parser.parse("size>= 12") 
          assert_equal( { :gteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
        should 'parse [op1] >= [op2]' do
          result = @parser.parse("size >= 12") 
          assert_equal( { :gteq => { :left => "size", :right => { :number => '12' } } }, result)
        end
      end
    end

    context 'operators' do
      context 'and' do
        should 'parse [comp]&&[comp]' do
          result = @parser.parse("name=myles&&size>=12") 
          assert_equal( { :and => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12'  } } } } }, result)
        end
      
        should 'parse [comp] &&[comp]' do
          result = @parser.parse("name=myles &&size>=12") 
          assert_equal( { :and => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
        end

        should 'parse [comp]&& [comp]' do
          result = @parser.parse("name=myles&& size>=12") 
          assert_equal( { :and => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
        end
        
        should 'parse [comp] && [comp]' do
          result = @parser.parse("name=myles && size>=12") 
          assert_equal( { :and => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
        end
      end

      context 'or' do
        should 'parse [comp]||[comp]' do
          result = @parser.parse("name=myles||size>=12") 
          assert_equal( { :or => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
        end
      
        should 'parse [comp] ||[comp]' do
          result = @parser.parse("name=myles ||size>=12") 
          assert_equal( { :or => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
        end

        should 'parse [comp]|| [comp]' do
          result = @parser.parse("name=myles|| size>=12") 
          assert_equal( { :or => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
        end
        
        should 'parse [comp] || [comp]' do
          result = @parser.parse("name=myles || size>=12") 
          assert_equal( { :or => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
        end
      end
    end

    context 'group' do
      should 'parse ([op] || [op])' do
        result = @parser.parse("(name=myles || size>=12)") 
        assert_equal( { :or => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } }, result)
      end
      
      should 'parse [op] || ([op] && [op])' do
        result = @parser.parse("name=myles || (job=programmer && size>=12)") 
        assert_equal( { :or => { :left => { :eq => { :left => 'name', :right => { :string => 'myles' } } }, :right => { :and => { :left => { :eq => { :left => 'job', :right => { :string => 'programmer' } } }, :right => { :gteq => { :left => 'size', :right => { :number => '12' } } } } } } }, result)
      end
    end
  end
end
