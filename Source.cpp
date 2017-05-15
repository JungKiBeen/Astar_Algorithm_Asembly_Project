#include <iostream>
#include <math.h>
#include <queue>
#include <math.h>
using namespace std;

struct city{
	it x;
	intn y;
};

struct path{
	double city[7];
	double cost;
	double distant;
	int current;
	int size;
	int list[7];
};

path P_pq[1000];
int current;
int now;

void P_pq_push(path k){
	P_pq[current] = k;
	current++;
	path temp;
	for (int i = now; i < current; i++){
		for (int j = now; j < current; j++){
			if (P_pq[i].cost < P_pq[j].cost){
				temp = P_pq[i];
				P_pq[i] = P_pq[j];
				P_pq[j] = temp;
			}

		}
	}
}

city Travel[7];

double dist(city a, city b){
	return sqrt((a.x - b.x)*(a.x - b.x) + (a.y - b.y)*(a.y - b.y));
}

void make_distant(path* p){
	p->distant = 0;
	for (int i = 1; i < 7; i++){
		if (p->list[i] != -1)
			p->distant += dist(Travel[p->list[i]], Travel[p->list[i - 1]]);
	}
}


bool is_visited(path P, int a){
	for (int i = 0; i < 7; i++){
		if (P.list[i] == a)
			return true;
	}
	return false;

}

	void PUSH(path now, int n_city){
		path next = now;
		next.city[n_city] = dist(Travel[now.current], Travel[n_city]);
		next.current = n_city;
		next.cost = next.city[0] + next.city[1] + next.city[2] + next.city[3] + next.city[4] + next.city[5] + next.city[6];
		next.list[now.size] = n_city;
		next.size = now.size + 1;
		make_distant(&next);
		P_pq_push(next);
	}

	void move(path P){
		if (now != current)
			now++;
		for (int i = 0; i < 7; i++){
			if (P.size != 7){
				if (is_visited(P, i) == false)
					PUSH(P, i);
			}
		}

	}


	bool check_goal(path P){
		if (P.list[6] == 6)
			return true;
		else
			return false;
	}

	void A_star(path P){
		int end;
		for (int i = 0; i < 7; i++)
			cout << P.list[i] + 1 << "	";
		cout << "distant : " << P.distant;
		cout << endl;
		if (check_goal(P)){
			cout << "Goal!" << endl;
			cin >> end;
		}

		move(P);
		A_star(P_pq[now]);
	}

	int main(void){

		Travel[0].x = 5, Travel[0].y = 5;
		Travel[1].x = 2, Travel[1].y = 3;
		Travel[2].x = 8, Travel[2].y = 4;
		Travel[3].x = 7, Travel[3].y = 2;
		Travel[4].x = 1, Travel[4].y = 6;
		Travel[5].x = 9, Travel[5].y = 6;
		Travel[6].x = 3, Travel[6].y = 2;

		path Sholtest;
		Sholtest.city[0] = 0;
		Sholtest.current = 0;
		Sholtest.list[0] = 0;
		Sholtest.size = 1;
		Sholtest.distant = 0;

		for (int i = 1; i < 7; i++){
			Sholtest.city[i] = 100;
			Sholtest.list[i] = -1;
			for (int j = 1; j < 7; j++){
				if (j != i){
					if (Sholtest.city[i] > dist(Travel[j], Travel[i]))
						Sholtest.city[i] = dist(Travel[j], Travel[i]);
				}
			}
		}

		P_pq_push(Sholtest);
		A_star(Sholtest);

}
