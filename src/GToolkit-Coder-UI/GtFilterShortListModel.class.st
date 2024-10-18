Class {
	#name : #GtFilterShortListModel,
	#superclass : #GtFilterSelectableItemModel,
	#instVars : [
		'itemsSelector'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #initialization }
GtFilterShortListModel >> displayAllItems [
	"Display all items, including the selected item in a dropdown list."

	itemsSelector := GtFilterModelAllItemsSelector new filterModel: self
]

{ #category : #initialization }
GtFilterShortListModel >> displayItemsWithoutSelectedItem [
	itemsSelector := GtFilterModelItemsWithoutSelectedItemSelector new filterModel: self
]

{ #category : #accessing }
GtFilterShortListModel >> filterViewModelClass [
	^ GtFilterShortListViewModel
]

{ #category : #initialization }
GtFilterShortListModel >> initialize [
	super initialize.
	itemsSelector := GtFilterModelItemsWithoutSelectedItemSelector new filterModel: self
]

{ #category : #accessing }
GtFilterShortListModel >> someItems [
	<return: #Collection of: #GtFilterModelItem>
	^ itemsSelector items
]
