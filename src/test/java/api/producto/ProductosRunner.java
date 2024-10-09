package api.producto;

import com.intuit.karate.junit5.Karate;

class ProductosRunner {

    @Karate.Test
    Karate testUsers() {
        return Karate.run("crear")
                .tags("@sinpermisos-404")
                .relativeTo(getClass());
    }

}