import Foundation

final class FillWithColor {
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        let height = image.count //height
        let width = image[0].count // width
        var goodImage = true;
        // проверка, чтобы все элементы картинки имели привильный цвет
        for i in image{
            if(!goodImage){
                break
            }
            for j in i{
                if(j < 0 || j >= 65536){
                    goodImage = false
                    break
                }
            }
        }
        //проверка на првильность входных значений
        if (goodImage && height >= 1 && height <= 50 && width >= 1 && width <= 50 &&
        newColor >= 0 && newColor < 65536 &&
        row >= 0 && row < height && column >= 0 && column < width){
            //копируем нашу картинку для работы
            var imageForWork = image
            //запоминаем цвет, который заменяем
            let oldColor = image[row][column]
            if (oldColor == newColor){
                return image
            }
            //Рекурсивная функция по заполнения соседних пикселей(по вертикали и горизонтали)
            func pixelFill(picture: inout [[Int]], pixel : (r: Int, c: Int) ) -> Void {
                if (pixel.r >= 0 && pixel.r < height &&
                        pixel.c >= 0 && pixel.c < width &&
                        picture[pixel.r][pixel.c] == oldColor) {
                    picture[pixel.r][pixel.c] = newColor
                    pixelFill(picture: &picture, pixel: (r: pixel.r-1, c: pixel.c))
                    pixelFill(picture: &picture, pixel: (r: pixel.r+1, c: pixel.c))
                    pixelFill(picture: &picture, pixel: (r: pixel.r, c: pixel.c+1))
                    pixelFill(picture: &picture, pixel: (r: pixel.r, c: pixel.c-1))
                }
            }
            //вызовов нашей рекурсии с точки, которую задали поменять
            pixelFill(picture: &imageForWork, pixel: (r: row, c: column))
            
            return imageForWork
        }else{
            return image
        }
    }
}
