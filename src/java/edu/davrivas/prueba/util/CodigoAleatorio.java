package edu.davrivas.prueba.util;

import java.util.Random;

public class CodigoAleatorio {

    public static String codigoAleatorio() {
        String plantilla = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        String codigo = "";

        for (int i = 0; i < 10; i++) {
            codigo += plantilla.charAt(new Random().nextInt(plantilla.length()));
        }

        return codigo;
    }

}
