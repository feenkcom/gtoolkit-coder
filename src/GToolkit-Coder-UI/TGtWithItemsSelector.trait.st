Trait {
	#name : #TGtWithItemsSelector,
	#instVars : [
		'itemsSelector'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #initialization }
TGtWithItemsSelector >> defaultItemsSelector [
	^ GtFilterModelItemsWithoutSelectedItemSelector new filterModel: self
]

{ #category : #initialization }
TGtWithItemsSelector >> displayAllItems [
	"Display all items, including the selected item in a dropdown list."

	self itemsSelector: (GtFilterModelAllItemsSelector new filterModel: self)
]

{ #category : #initialization }
TGtWithItemsSelector >> displayItemsWithoutSelectedItem [
	self itemsSelector: (GtFilterModelItemsWithoutSelectedItemSelector new filterModel: self)
]

{ #category : #accessing }
TGtWithItemsSelector >> itemsSelector [
	<return: #GtFilterModelItemsSelector>
	^ itemsSelector ifNil: [ itemsSelector := self defaultItemsSelector ]
]

{ #category : #accessing }
TGtWithItemsSelector >> itemsSelector: anItemsSelector [
	itemsSelector := anItemsSelector
]

{ #category : #accessing }
TGtWithItemsSelector >> someItems [
	"Return items that should be displayed in a list"

	<return: #Collection of: #GtFilterModelItem>
	^ self itemsSelector items
]

{ #category : #accessing }
TGtWithItemsSelector >> someItemsFuture [
	"Return an async future that computes list items"

	<return: #TAsyncFuture>
	^ self itemsSelector itemsFuture asAsyncFuture
]
