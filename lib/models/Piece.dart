class Piece {
  String name;
  String image;
  String description;
  int price;
  Piece({required this.name,required this.image,required this.description,
  required this.price});

  static List<Piece> getPieces() {
    return List.of([
      Piece(
          name: "Red Hoodie",
          image: 'https://www.instockshowroom.com/cdn/shop/products/1001PULLP_RED_1_1024x1024.jpg?v=1652205426',
          description: "A cozy red hoodie made of premium cotton.",
          price: 50),
      Piece(
          name: "Denim Jacket",
          image: 'https://www.harley-davidson.com/content/dam/h-d/images/product-images/merchandise/2022/july-replenishment/99040-23vw/99040-23VW_F.jpg?impolicy=myresize&rw=700',
          description: "Classic blue denim jacket for all seasons.",
          price: 80),
      Piece(
          name: "Black T-shirt",
          image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVUiAXqebFGhhyfNxBFz1QWw9BMxEkrMjckw&s',
          description: "Simple and stylish black t-shirt for casual wear.",
          price: 25),
      Piece(
          name: "Leather Jacket",
          image: 'https://www.mrporter.com/variants/images/1647597286006989/in/w2000_q60.jpg',
          description: "Premium black leather jacket for a rugged look.",
          price: 120),
      Piece(
          name: "Summer Dress",
          image: 'https://www.lilyboutique.com/media/catalog/product/cache/1/image/560x840/9df78eab33525d08d6e5fb8d27136e95/1/0/104_55_.jpg',
          description: "White and elegant summer dress.",
          price: 40),
      Piece(
          name: "Sports Cap",
          image: 'https://i.etsystatic.com/21657310/r/il/5521a5/4699496919/il_570xN.4699496919_9bn4.jpg',
          description: "Adjustable black sports cap for sunny days.",
          price: 15),
      Piece(
          name: "Plaid Shirt",
          image: 'https://www.yoopershirts.com/cdn/shop/products/FLANNEL-RED-2021_42f55e95-0264-47f9-8a3c-760c99215616_600x.png?v=1636139482',
          description: "Casual red and black plaid shirt.",
          price: 35),
      Piece(
          name: "Nike Shirt",
          image: 'https://cdn.mainlinemenswear.co.uk/f_auto,q_auto/mainlinemenswear/shopimages/products/158025/Mainimage.jpg',
          description: "Nike white sport t-shirt.",
          price: 45),
      Piece(
          name: "Striped Polo Shirt",
          image: 'https://shop.vogue.com/cdn/shop/files/VogueGreenStripePoloFront.png?v=1689867553',
          description: "Blue and white striped polo shirt for semi-casual wear.",
          price: 35),
      Piece(
        name: "Slim Fit Chinos",
        image: "https://image.hm.com/assets/hm/4d/24/4d246faa55763fd10d1ebc11bb33219eaa3e57ba.jpg?imwidth=2160",
        description: "Comfortable and stylish slim-fit chinos for a smart-casual look.",
        price: 40,
      ),
      Piece(
        name: "Hooded Sweatshirt",
        image: "https://m.media-amazon.com/images/I/71gEWlwpN9L._AC_UY1000_.jpg",
        description: "A cozy hooded sweatshirt for chilly days, made from premium fleece.",
        price: 35,
      ),
      Piece(
        name: "Casual T-Shirt",
        image: "https://images.napali.app/global/element-products/all/default/large/elyzt00434_element,f_bln0_frt1.jpg",
        description: "A soft cotton T-shirt for everyday wear, available in various colors.",
        price: 20,
      ),
    ]);
  }

}

