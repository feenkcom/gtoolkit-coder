Class {
	#name : #GtFilterModelItemsWithoutSelectedItemSelector,
	#superclass : #GtFilterModelItemsSelector,
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'as yet unclassified' }
GtFilterModelItemsWithoutSelectedItemSelector >> items [
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel items reject: [ :each | self selectedItem = each ]
]

{ #category : #'as yet unclassified' }
GtFilterModelItemsWithoutSelectedItemSelector >> itemsFuture [
	<return: #TAsyncFuture of: #Collection of: #GtFilterModelItem>
	^ self filterModel itemsFuture map: [ :anArray | 
		anArray reject: [ :each | self selectedItem = each ] ]
]
