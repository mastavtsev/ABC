#include <unistd.h>
#include <pthread.h>
#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <fstream>


int acceptedElements = 0; /// количество приинятых элементов
int *A;                   /// общий массив
int arrSize;              /// размер массива А
pthread_rwlock_t rwlock;  /// блокировка чтения-записи
pthread_mutex_t mutexD;   /// мьютекс для операции записи


bool write_to_file = false;         /// необходимости вывода информации в файл - настраивается при старте программы
std::fstream output("output.txt");  /// поток для вывода в файл output.txt

std::vector<int> worker1Vec;    /// булавки для оценки первым работнком - индексы в общем массиве А
std::vector<int> worker2Vec;    /// булавки для оценки первым работнком - индексы в общем массиве А
std::vector<int> worker3Vec;    /// булавки для оценки первым работнком - индексы в общем массиве А

/// Получения случайного целого числа на интервале (a, b)
int getRandom(int a, int b) {
    std::random_device r;
    std::default_random_engine engine(r());
    std::uniform_int_distribution<int> dist(a, b);
    return dist(engine);
}

///  Вывод в случае одобрения булавки со стороны работника номер rNum
void outputReadPassedResults(int rNum, int index, int a) {

    pthread_mutex_lock(&mutexD);  //защита операции записи
    std::cout << " Element[" << index << "] -> " << a << " passed examination by worker-reader "
              << rNum << std::endl;

    /// Вывод в файл при необходимости
    if (write_to_file) {
        output << " Element[" << index << "] -> " << a << " passed examination by worker-reader "
               << rNum << std::endl;
    }

    pthread_mutex_unlock(&mutexD);
}

///  Вывод в случае брака булавки со стороны работника номер rNum
void outputReadFailedResults(int rNum, int index, int a) {

    pthread_mutex_lock(&mutexD);  /// защита операции записи
    std::cout << " Element[" << index << "] -> " << a << " failed examination by worker-reader "
              << rNum << std::endl;

    /// Вывод в файл при необходимости
    if (write_to_file) {
        output << " Element[" << index << "] -> " << a << " failed examination by worker-reader "
               << rNum << std::endl;
    }

    pthread_mutex_unlock(&mutexD);
}

void worker1Read() {

    /// Получение размера вектора с доступными для обработки булавками
    int vec_size = int(worker1Vec.size());

    /// Если есть булавки для обработки
    if (vec_size > 0) {
        /// получить случайный индекс
        int index = worker1Vec[getRandom(0, vec_size - 1)];

        /// закрыть блокировку для чтения
        pthread_rwlock_rdlock(&rwlock);

        /// прочитать данные из общего массива – критическая секция
        int a = A[index];

        /// открыть блокировку
        pthread_rwlock_unlock(&rwlock);

        /// Если оценка булавки попадает в интервалп принимаемый первым работником, то
        /// данная булвка переходит для оценки ко второму работнику
        if (10 <= a && a <= 20) {

            /// Вывод успешного результата в консоль и опционально в файл output.txt
            outputReadPassedResults(1, index, a);

            pthread_rwlock_wrlock(&rwlock); /// закрыть блокировку для записи

            /// изменить элементы общих векторов – критическая секция
            worker1Vec.erase(std::remove(worker1Vec.begin(), worker1Vec.end(), index),
                             worker1Vec.end());  /// erase-remove idiom
            worker2Vec.push_back(index);

            pthread_rwlock_unlock(&rwlock); /// открыть блокировку для записи

        } else {
            /// Вывод отрицательного результата в консоль и опционально в файл output.txt
            outputReadFailedResults(1, index, a);
        }
    }

    sleep(2);
}

void worker2Read() {
    /// Получение размера вектора с доступными для обработки булавками
    int vec_size = int(worker2Vec.size());

    /// Если есть булавки для обработки
    if (vec_size > 0) {
        int index = worker2Vec[getRandom(0, vec_size - 1)];  /// получить случайный индекс

        /// закрыть блокировку для чтения
        pthread_rwlock_rdlock(&rwlock);

        /// прочитать данные из общего массива – критическая секция
        int a = A[index];

        /// открыть блокировку
        pthread_rwlock_unlock(&rwlock);

        /// Если оценка булавки попадает в интервалп принимаемый вторым работником, то
        /// данная булвка переходит для оценки к третьему работнику
        if (20 <= a && a <= 30) {
            /// Вывод успешного результата в консоль и опционально в файл output.txt
            outputReadPassedResults(2, index, a);

            pthread_rwlock_wrlock(&rwlock); /// закрыть блокировку для записи

            /// изменить элементы общих векторов – критическая секция
            worker2Vec.erase(std::remove(worker2Vec.begin(), worker2Vec.end(), index),
                             worker2Vec.end());  /// erase-remove idiom
            worker3Vec.push_back(index);

            pthread_rwlock_unlock(&rwlock); /// открыть блокировку для записи
        } else {
            /// Вывод отрицательного результата в консоль и опционально в файл output.txt
            outputReadFailedResults(2, index, a);
        }
    }

    sleep(2);
}

void worker3Read() {
    /// Получение размера вектора с доступными для обработки булавками
    int vec_size = int(worker3Vec.size());

    /// Если есть булавки для обработки
    if (vec_size > 0) {
        int index = worker3Vec[getRandom(0, vec_size - 1)];  /// получить случайный индекс

        /// закрыть блокировку для чтения
        pthread_rwlock_rdlock(&rwlock);

        /// прочитать данные из общего массива – критическая секция
        int a = A[index];

        /// открыть блокировку
        pthread_rwlock_unlock(&rwlock);

        /// Если оценка булавки попадает в интервалп принимаемый третьим работником, то
        /// данная булвка принимается и увеличивается значение acceptedElements.
        /// В противном случае её оценка производится повторно.
        if (40 <= a && a <= 60) {
            /// Вывод успешного результата в консоль и опционально в файл output.txt
            outputReadPassedResults(3, index, a);

            pthread_rwlock_wrlock(&rwlock); /// закрыть блокировку для записи

            worker3Vec.erase(std::remove(worker3Vec.begin(), worker3Vec.end(), index),
                             worker3Vec.end());  /// erase-remove idiom

            pthread_rwlock_unlock(&rwlock); /// открыть блокировку для записи

            /// Увелечение принятых элементов на единицу.
            acceptedElements++;
        } else {
            /// Вывод отрицательного результата в консоль и опционально в файл output.txt
            outputReadFailedResults(3, index, a);
        }
    }

    sleep(2);
}

void *funcRead(void *param) {
    /// Получение номера потока - 1, 2 или 3. Номер потока соответсвует
    /// номеру роботника.
    int rNum = *((int *)param);

    /// Работы потоков продолжается до того момента, как будут обработа все элементы массива
    while (acceptedElements != arrSize) {

        /// Распределние потоков для чтения в зависимости от их номеров
        switch (rNum) {
            case 1:
                worker1Read();
                break;
            case 2:
                worker2Read();
                break;
            case 3:
                worker3Read();
                break;
            default:
                break;
        }

        sleep(2);
    }
    return nullptr;
}

void outputWriteResults(int wNum, int index) {
    pthread_mutex_lock(&mutexD);  /// защита операции вывода
    std::cout << "Worker-writer " << wNum << " examined Element[" << index << "] -> " << A[index]
              << std::endl;

    if (write_to_file) {
        output << "Worker-writer " << wNum << " examined Element[" << index << "] -> " << A[index]
               << std::endl;
    }

    pthread_mutex_unlock(&mutexD);
}

void worker1Write() {

    /// Получение размера вектора с доступными для обработки булавками
    int vec_size = int(worker1Vec.size());

    /// Если есть булавки для обработки
    if (vec_size > 0) {

        int index = worker1Vec[getRandom(0, vec_size - 1)];  /// получить случайный индекс

        /// закрыть блокировку для записи
        pthread_rwlock_wrlock(&rwlock);
        /// изменить элемент общего массива – критическая секция

        /// Первый работник даёт оценку в интервале от 5 до 20
        A[index] = getRandom(5, 20);

        /// открыть блокировку
        pthread_rwlock_unlock(&rwlock);

        /// Вывод результатов в консоль и опционально в файл output.txt
        outputWriteResults(1, index);
    }
}

void worker2Write() {

    /// Получение размера вектора с доступными для обработки булавками
    int vec_size = int(worker2Vec.size());

    /// Если есть булавки для обработки
    if (vec_size > 0) {

        /// получить случайный индекс
        int index = worker2Vec[getRandom(0, vec_size - 1)];

        /// закрыть блокировку для записи
        pthread_rwlock_wrlock(&rwlock);
        /// изменить элемент общего массива – критическая секция

        /// Второй работник даёт оценку в интервале от 15 до 30
        A[index] = getRandom(15, 30);

        /// открыть блокировку
        pthread_rwlock_unlock(&rwlock);

        /// Вывод результатов в консоль и опционально в файл output.txt
        outputWriteResults(2, index);
    }
}

void worker3Write() {
    /// Получение размера вектора с доступными для обработки булавками
    int vec_size = int(worker3Vec.size());

    /// Если есть булавки для обработки
    if (vec_size > 0) {
        /// получить случайный индекс
        int index = worker3Vec[getRandom(0, vec_size - 1)];

        /// закрыть блокировку для записи
        pthread_rwlock_wrlock(&rwlock);

        /// изменить элемент общего массива – критическая секция

        /// Третий работник даёт оценку в интервале от 35 до 60
        A[index] = getRandom(35, 60);

        /// открыть блокировку
        pthread_rwlock_unlock(&rwlock);

        /// Вывод результатов в консоль и опционально в файл output.txt
        outputWriteResults(3, index);
    }
}

void *funcWrite(void *param) {
    int wNum = *((int *)param); /// Получение номера потока - 1, 2 или 3. Номер потока соответсвует
                                /// номеру роботника.

    /// Работы потоков продолжается до того момента, как будут обработа все элементы массива
    while (acceptedElements != arrSize) {

        /// Распределние потоков для записи в зависимости от его номера
        switch (wNum) {
            case 1:
                worker1Write();
                break;
            case 2:
                worker2Write();
                break;
            case 3:
                worker3Write();
                break;
            default:
                break;
        }

        sleep(3);
    }
    return nullptr;
}


int main(int argc, char **argv) {

    /// Получение типа ввода из консоли
    int type;
    std::cout << "Type in the console the type of input you want: \n"
              << "1 - console (output in console) \n"
              << "2 - file input (output in output.txt + console) \n"
              << "3 - random input (output in console)" << std::endl;

    std::cout << "Input type:_";
    std::cin >> type;
    std::cout << std::endl;

    /// Получение размера массива в зависимости от типа ввыода
    if (type == 1) {
        std::cout << "Input the number of nails:_  ";
        std::cin >> arrSize;
        std::cout << std::endl;
    } else if (type == 2) {
        write_to_file = true;

        /// Проверка на корректность аргументов командной строки
        if (argc != 2) {
            std::cout << "You haven't entered the path to input file!";
            return 0;
        }

        std::fstream myfile(argv[1]);
        myfile >> arrSize;
    } else if (type == 3) {
        arrSize = getRandom(2, 7);
        std::cout << "The random size is " << arrSize << std::endl;
    } else {
        std::cout << "Wrong type!";
        return 0;
    }


    if (arrSize <= 0) {
        std::cout << "Incorrect value of array size!";
        return 0;
    }

    A = new int[arrSize]; /// Выделение памяти под общий массив

    /// инициализация блокировки чтения-записи
    pthread_rwlock_init(&rwlock, nullptr);
    /// заполнение общего массива
    for (int i = 0; i < arrSize; i++) {
        A[i] = getRandom(0, 10);
        worker1Vec.push_back(i);
    }

    /// создание трех потоков-писателей
    pthread_t threadW[3];
    int writers[3];
    for (int i = 0; i < 3; i++) {
        writers[i] = i + 1;
        pthread_create(&threadW[i], nullptr, funcWrite, (void *)(writers + i));
    }

    /// создание трёх потоков-читателей
    pthread_t threadR[3];
    int readers[3];
    for (int i = 0; i < 3; i++) {
        readers[i] = i + 1;
        pthread_create(&threadR[i], nullptr, funcRead, (void *)(readers + i));
    }

    /// пусть главный поток будет потоком-писателем
    int mNum = 1;
    funcWrite((void *)&mNum);

    std::cout << "\nProcess has finished!";
    if (write_to_file) {
        output << "\nProcess has finished!";
    }

    delete[] A; /// очистка выделенной памяти
    return 0;
}
