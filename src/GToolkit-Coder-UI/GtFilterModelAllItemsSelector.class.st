Class {
	#name : #GtFilterModelAllItemsSelector,
	#superclass : #GtFilterModelItemsSelector,
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelAllItemsSelector >> items [
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel items
]

{ #category : #accessing }
GtFilterModelAllItemsSelector >> itemsFuture [
	<return: #TAsyncFuture of: #Collection of: #GtFilterModelItem>
	^ self filterModel itemsFuture
]
