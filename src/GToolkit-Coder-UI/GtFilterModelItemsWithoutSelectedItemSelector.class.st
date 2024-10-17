Class {
	#name : #GtFilterModelItemsWithoutSelectedItemSelector,
	#superclass : #GtFilterModelItemsSelector,
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'as yet unclassified' }
GtFilterModelItemsWithoutSelectedItemSelector >> items [
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel items reject: [ :each | self selectedItem = each ]
]
