Trait {
	#name : #TGtWithSelectableItem,
	#instVars : [
		'selectedItem',
		'itemsBuilder'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
TGtWithSelectableItem >> items [
	<return: #Collection of: #GtFilterModelItem>
	self deprecated: 'Use #itemsFuture instead'.
	
	^ itemsBuilder create
]

{ #category : #accessing }
TGtWithSelectableItem >> items: anObject [
	self itemsBuilder: anObject
]

{ #category : #accessing }
TGtWithSelectableItem >> items: anObject icon: anIconStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			iconStencilBuilder: anIconStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
TGtWithSelectableItem >> items: anObject icon: anIconStencilBuilder label: aLabelStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			iconStencilBuilder: anIconStencilBuilder;
			labelStencilBuilder: aLabelStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
TGtWithSelectableItem >> items: anObject label: aLabelStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			labelStencilBuilder: aLabelStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
TGtWithSelectableItem >> itemsBuilder [
	<return: #GtFilterModelItemsBuilder>
	^ itemsBuilder ifNil: [ 
		itemsBuilder := GtFilterModelEmptyItemsBuilder default ]
]

{ #category : #accessing }
TGtWithSelectableItem >> itemsBuilder: anObject [
	| aNewItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	self itemsBuilder = aNewItemsBuilder ifTrue: [ ^ self ].
	itemsBuilder := aNewItemsBuilder.
	aNewItemsBuilder filterModel: self.

	self notifyItemsChanged
]

{ #category : #accessing }
TGtWithSelectableItem >> itemsFuture [
	<return: #TAsyncFuture of: #Collection of: #GtFilterModelItem>
	^ itemsBuilder createFuture
]

{ #category : #'private - notifying' }
TGtWithSelectableItem >> notifyItemsChanged [
	self explicitRequirement
]

{ #category : #'private - notifying' }
TGtWithSelectableItem >> notifySelectedItemChanged [
	self explicitRequirement
]

{ #category : #accessing }
TGtWithSelectableItem >> selectedItem [
	^ selectedItem ifNil: [ selectedItem := GtFilterModelNoItem default ]
]

{ #category : #accessing }
TGtWithSelectableItem >> selectedItem: anItem [
	| aNewItem |
	aNewItem := anItem asFilterModelItem.
	self selectedItem = aNewItem ifTrue: [ ^ self ].

	selectedItem := aNewItem.
	self notifySelectedItemChanged
]

{ #category : #accessing }
TGtWithSelectableItem >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ self selectedItem
]

{ #category : #initialization }
TGtWithSelectableItem >> selectFirstItem [
	self itemsBuilder firstItemDo: [ :anItem | self selectedItem: anItem ]
]

{ #category : #initialization }
TGtWithSelectableItem >> selectItemAt: anIndex [
	self itemsBuilder itemAt: anIndex do: [ :anItem | self selectedItem: anItem ]
]

{ #category : #initialization }
TGtWithSelectableItem >> selectLastItem [
	self itemsBuilder lastItemDo: [ :anItem | self selectedItem: anItem ]
]
