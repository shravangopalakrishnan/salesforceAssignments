public class Fitness {
    
    public static Decimal calculateBMI(Decimal weight, Decimal height){
        if(height == 0 || weight == 0){
            throw new IllegalArgumentException('Dimensions cannot be 0');
        }
        Decimal bmi = weight / (height * height);
        return bmi.setScale(2, RoundingMode.HALF_UP);
    }

    public static Decimal calculatePace(Decimal kilometers, Decimal hours){
        
        if(hours == 0){
            throw new IllegalArgumentException('Time cannot be 0');
        }
        
        Decimal minutes = hours * 60;
        Decimal pace = kilometers / minutes;
        return pace.setScale(2, RoundingMode.HALF_UP);
    }
}

