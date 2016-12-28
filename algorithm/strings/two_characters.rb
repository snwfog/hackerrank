# s   = 'muqqzbcjmyknwlmlcfqjujabwtekovkwsfjrwmswqfurtpahkdyqdttizqbkrsmfpxchbjrbvcunogcvragjxivasdykamtkinxpgasmwz'
# s = 'beabeefeab'
# s = 'a'
# s = 'ab'
# s = 'aa'
# s   = 'uyetuppelecblwipdsqabzsvyfaezeqhpnalahnpkdbhzjglcuqfjnzpmbwprelbayyzovkhacgrglrdpmvaexkgertilnfooeazvulykxypsxicofnbyivkthovpjzhpohdhuebazlukfhaavfsssuupbyjqdxwwqlicbjirirspqhxomjdzswtsogugmbnslcalcfaxqmionsxdgpkotffycphsewyqvhqcwlufekxwoiudxjixchfqlavjwhaennkmfsdhigyeifnoskjbzgzggsmshdhzagpznkbahixqgrdnmlzogprctjggsujmqzqknvcuvdinesbwpirfasnvfjqceyrkknyvdritcfyowsgfrevzon'
s = 'czoczkotespkfjnkbgpfnmtgqhorrzdppcebyybhlcsplqcqogqaszjgorlsrppinhgpaweydclepyftywafupqsjrbkqakpygolyyfksvqetrfzrcmatlicxtcxulwgvlnslazpfpoqrgssfcrfvwbtxaagjfahcgxbjlltfpprpcjyivxu'
# s   = 'cwomzxmuelmangtosqkgfdqvkzdnxerhravxndvomhbokqmvsfcaddgxgwtpgpqrmeoxvkkjunkbjeyteccpugbkvhljxsshpoymkryydtmfhaogepvbwmypeiqumcibjskmsrpllgbvc'


r = /([a-z])\1/
# clean up all duplicates that needs to be removed
while s =~ r do
  s.scan(r).each do |match|
    c = match[0]
    s.gsub!(c, '')
  end
end

if s.empty? or s.length <= 1
  puts 0
else
  trash     = []
  distances = {} # Characters between a character from left to right, first come first server
  buckets   = {}
  s.each_char do |char|
    new_buckets = {}
    # Update distance
    distances.each do |k, v|
      if distances[k][-1] == k
        # This case means we've reached final distance
      else
        distances[k] += char
      end
    end

    buckets.each do |k, v|
      if k.length == 1
        new_key = k + char
        if not buckets.has_key?(new_key) and not trash.include?(new_key)
          if (distances.has_key?(k) and distances[k][-1] != k) # Not final distance yet
            if (distances.has_key?(char) and distances[char][-1] == char and distances[char].include?(k))
              new_buckets[new_key] = new_key
            elsif (distances.has_key?(char) and distances[char][-1] != char)
              # Not an useful combination, as the char will be the end character
            elsif not distances.has_key?(char)
              new_buckets[new_key] = new_key
            end
          elsif (distances.has_key?(k) and distances[k][-1] == k and not distances[k].include?(char))
            # Means this combination exists but is not going to be valid
            trash.push(new_key)
            buckets.delete(new_key)
          elsif (distances.has_key?(k) and distances[k][-1] != k and distances[k].include?(char))
            # Valid combination
            new_buckets[new_key] = new_key
          end
        end
        next
      end

      # Takes care of double same char with no valid
      # separator in between
      if v[-1] == char
        buckets.delete(k)
        trash.push(v[0..1])
        next
      end

      unless trash.include?(v[0..1])
        if distances.has_key?(v[0]) and distances[v[0]].include?(char)
          if v.length.odd? and v[1] == char and
            buckets[k] += char
          end

          if v.length.even? and v[0] == char
            buckets[k] += char
          end
        end
      end
    end

    buckets = buckets.merge(new_buckets)

    if not buckets.has_key?(char) and not distances.has_key?(char)
      buckets[char]   = char # New character
      distances[char] = ''
    end
  end
end

max = buckets
        .values
        .select { |v| v.length > 1 }
        .max { |a, b| a.length <=> b.length }

puts max ? max.length : 0



