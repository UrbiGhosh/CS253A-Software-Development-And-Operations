#include <bits/stdc++.h>
using namespace std;
int main() 
{ 
	#ifndef ONLINE_JUDGE
    freopen("array","r",stdin);
    freopen("reduced_tests","w",stdout);
    #endif
    
    int n, k, r,flag;
    cin >>n>>k>>r;

    int arr[n][r];
    for( int i=0;i<n;i++)
        for(int j=0;j<r;j++)
            cin>>arr[i][j];
    int ans[k];
    for(int x=0;x<k;x++)
    {
        int sum[n];
        for (int y=0;y<n;y++)
        {
            sum[y]=0;
            for(int z=0;z<r;z++)
            {
                sum[y]+=arr[y][z];
            }
        }//defined a sum for each line. this sum is re-evaluated for every k
            
        if(*max_element(sum,sum+n)>0)
        {
            flag=distance(sum, max_element(sum, sum + n));//obtain greatest sum over all rows
            ans[x]=flag;
        }
        else ans[x]=-1;

        for (int y=0;y<r;y++)
        {
            for(int z=0;z<n;z++)
            {
                if(z==flag)continue;
                if(arr[flag][y]==1)arr[z][y]=0;
            }
            arr[flag][y]=0;
        }//updating matrix
    }
    sort(ans, ans+k);
    for(int x=0;x<k;x++){if(ans[x]>-1){cout<<ans[x]<<"\n";}}

}
