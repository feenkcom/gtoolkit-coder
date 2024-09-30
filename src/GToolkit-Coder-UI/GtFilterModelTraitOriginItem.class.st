Class {
	#name : #GtFilterModelTraitOriginItem,
	#superclass : #GtFilterModelMethodOriginItem,
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelTraitOriginItem >> icon [
	^ self iconNamed: #trait
]

{ #category : #testing }
GtFilterModelTraitOriginItem >> isTraitOrigin [
	^ true
]

{ #category : #accessing }
GtFilterModelTraitOriginItem >> label [
	^ 'trait'
]
