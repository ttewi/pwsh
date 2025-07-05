<<<<<<< HEAD
class mm3{
    mm3(){}


    [uint64]_x86multiply($m,$n) {
        return ( ( $m -band 0xffff ) * $n  ) + ( ( ( ( $m -shr 16 ) * $n ) -band 0xffff ) -shl 16 )
        #write-host ( ( ( $m -band 0xffff ) * $n  ) )
        #return 1
    }

    [uint64]_x86rotl($m,$n) {
        #return ($m -shl $n) -bor ($m -shr (32 - $n))
        #write-host ( ( ($m -band 0xffff) -shl $n ) -bor ( $m -shr ( 32 - $n ) ) )
        write-host ( ( ($m -band 0xffff) -shl $n ) )
        $t=($m -band 0xffff)
        write-host $t
        write-host (( $m -shr ($m -shl ( [system.Runtime.InteropServices.marshal]::sizeof($m)*8 - $n ) ) ) )
        return ($m -shl $n)
    }

    [int64]hash($key) {return $this.hash($key,0)}
    [int64]hash($key,$seed) {
        if (!$key){$key=''}
        w("<gray>$($key)\n")

        $keyl=$key.length

        $remainder=$keyl % 4; #w("<gray>$($remainder)\n");
        $bytes=$keyl-$remainder

        $h1=$seed

        $k1=0

        $c1=3432918353
        write-host $c1
        $c2=[int32]0x1b873593

        # >>> [uint64]$number -shr 8

        for ($i=0;$i-le$bytes;$i+=4) {
            w("<#c9a0dc>(for) $($i) \n")
            #! not verified srry
            $k1= ( [int][char]$key[$i] -band 0xff ) -bor ( ([int][char]$key[$i+1] -band 0xff) -shl 8 ) -bor ( ([int][char]$key[$i+2] -band 0xff) -shl 16 ) -bor ( ([int][char]$key[$i+3] -band 0xff) -shl 24 )
            w('<yellow>$k1 <gray>'+$k1+'\n')
            write-host '#'

            $k1=$this._x86multiply($k1,$c1)
            w('<yellow>$k1 <gray>'+$k1+'\n')

            $k1=$this._x86rotl($k1,15)



            
            w('<yellow>$k1 <gray>'+$k1+'\n')
        }


        w('\n')
        return 1
    }
}
$mm3=[mm3]::new()


=======
class mm3{
    mm3(){}


    [uint64]_x86multiply($m,$n) {
        return ( ( $m -band 0xffff ) * $n  ) + ( ( ( ( $m -shr 16 ) * $n ) -band 0xffff ) -shl 16 )
        #write-host ( ( ( $m -band 0xffff ) * $n  ) )
        #return 1
    }

    [uint64]_x86rotl($m,$n) {
        #return ($m -shl $n) -bor ($m -shr (32 - $n))
        #write-host ( ( ($m -band 0xffff) -shl $n ) -bor ( $m -shr ( 32 - $n ) ) )
        write-host ( ( ($m -band 0xffff) -shl $n ) )
        $t=($m -band 0xffff)
        write-host $t
        write-host (( $m -shr ($m -shl ( [system.Runtime.InteropServices.marshal]::sizeof($m)*8 - $n ) ) ) )
        return ($m -shl $n)
    }

    [int64]hash($key) {return $this.hash($key,0)}
    [int64]hash($key,$seed) {
        if (!$key){$key=''}
        w("<gray>$($key)\n")

        $keyl=$key.length

        $remainder=$keyl % 4; #w("<gray>$($remainder)\n");
        $bytes=$keyl-$remainder

        $h1=$seed

        $k1=0

        $c1=3432918353
        write-host $c1
        $c2=[int32]0x1b873593

        # >>> [uint64]$number -shr 8

        for ($i=0;$i-le$bytes;$i+=4) {
            w("<#c9a0dc>(for) $($i) \n")
            #! not verified srry
            $k1= ( [int][char]$key[$i] -band 0xff ) -bor ( ([int][char]$key[$i+1] -band 0xff) -shl 8 ) -bor ( ([int][char]$key[$i+2] -band 0xff) -shl 16 ) -bor ( ([int][char]$key[$i+3] -band 0xff) -shl 24 )
            w('<yellow>$k1 <gray>'+$k1+'\n')
            write-host '#'

            $k1=$this._x86multiply($k1,$c1)
            w('<yellow>$k1 <gray>'+$k1+'\n')

            $k1=$this._x86rotl($k1,15)



            
            w('<yellow>$k1 <gray>'+$k1+'\n')
        }


        w('\n')
        return 1
    }
}
$mm3=[mm3]::new()


>>>>>>> 9faad1be1c4a01cda605ea0a4318101187009d24
$mm3.hash('test')