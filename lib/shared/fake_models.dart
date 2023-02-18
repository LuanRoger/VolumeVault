import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/user_info_model.dart';

UserInfoModel fakeUserModel = UserInfoModel(1,
    username: "Luan Roger", email: "luan.roger.2003@gmail.com");

BookModel fakeBookModel = BookModel(
    0, "Harry Potter", "J.K. Rowling", "978-85-7683-393-2",
    publicationYear: 1992,
    publisher: "Rocco",
    edition: 1,
    pagesNumber: 208,
    genre: "Fantasia",
    format: BookFormat.HARDBACK,
    observation: "I need to reed more",
    synopsis:
        "Harry Potter é um garoto cujos pais, feiticeiros, foram assassinados por um poderosíssimo bruxo quando ele ainda era um bebê. Harry Potter é uma série de sete romances de fantasia escrita pela autora britânica J. K. Rowling. A série narra as aventuras de um jovem chamado Harry James Potter, que descobre aos 11 anos de idade que é um bruxo ao ser convidado para estudar na Escola de Magia e Bruxaria de Hogwarts. O arco de história principal diz respeito às amizades de Harry com outros bruxos de sua idade, como Ron Weasley e Hermione Granger, e também com o diretor de Hogwarts Albus Dumbledore, considerado o maior dos magos, e seus conflitos com o bruxo das trevas Lord Voldemort, que pretende se tornar imortal, conquistar o mundo dos bruxos, subjugar as pessoas não-mágicas e destruir todos aqueles que estão em seu caminho, especialmente Harry Potter, a quem ele considera seu maior rival.",
    coverLink: "https://m.media-amazon.com/images/I/81ibfYk4qmL.jpg",
    buyLink:
        "https://www.amazon.com.br/Harry-Potter-Pedra-Filosofal-Rowling/dp/8532530788/ref=asc_df_8532530788/?tag=googleshopp00-20&linkCode=df0&hvadid=379795242161&hvpos=&hvnetw=g&hvrand=4863720407530529741&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9074237&hvtargid=pla-569630960550&psc=1",
    readed: true,
    createdAt: DateTime.now(),
    lastModification: DateTime.now(),
    owner: fakeUserModel);
