Class {
	#name : #GtFilterShortListViewModel,
	#superclass : #GtFilterSelectableItemViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterShortListViewModel >> filterElementClass [
	^ GtFilterShortListSettingsElement
]

{ #category : #accessing }
GtFilterShortListViewModel >> someItems [
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel someItems
]

{ #category : #accessing }
GtFilterShortListViewModel >> someItemsFuture [
	"Return an async future that computes list items"

	<return: #TAsyncFuture>
	^ self filterModel someItemsFuture
]
