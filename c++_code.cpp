//=============== THE CODE IN C++ ==========================

int binary_search(int *A, int N, int key) {
  return binary_search_rec(A, 0, N-1, key);
}

int binary_search_rec(int *A, int left, int right, int key) {
  int mid;
  if (right < left) return -1;
  mid = left + (right – left) / 2;
  if (A[mid] == key) return mid;
  else if (A[mid] > key)
    return binary_search_rec(A, left, mid-1, key);
  else
    return binary_search_rec(A, mid+1, right, key);
}

int exponential_search(int *A, int N, int key) {
  int bound = 1;
  while(bound < N && A[bound] < key) {
    bound *=2;
  }
  if (bound < N-1)
    return binary_search_rec(A, bound/2, bound, key);
  else
    return binary_search_rec(A, bound/2, N-1, key);
 }
 
int interpolation_search(int *A, int N, int key) {
  int low = 0, up = N-1, pos;
  while (low <= up) {
    if ((key < A[low]) || (key > A[up]))
      return -1;
    pos = low + (up-low) * (key-A[low])/(A[up]-A[low]);
    if (A[pos] == key)
      return pos;
    else if (A[pos] > key)
      up = pos – 1;
    else
      low = pos+1;
  }
  return -1;
}
