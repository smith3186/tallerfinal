package api.producto;

import com.intuit.karate.junit5.Karate;

class ProductosRunner {

    @Karate.Test
    Karate testUsers() {
        return Karate.run("crear")
                .tags("@crear")
                .relativeTo(getClass());
    }

}