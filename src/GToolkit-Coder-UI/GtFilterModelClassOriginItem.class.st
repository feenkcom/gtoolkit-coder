Class {
	#name : #GtFilterModelClassOriginItem,
	#superclass : #GtFilterModelMethodOriginItem,
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelClassOriginItem >> icon [
	^ self iconNamed: #class
]

{ #category : #accessing }
GtFilterModelClassOriginItem >> label [
	^ 'non-trait'
]
