Trait {
	#name : #TGtWithFiltersModel,
	#instVars : [
		'filterModels'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'api - filter model' }
TGtWithFiltersModel >> filtersModel [
	self
		assert: [ filterModels isNotNil ]
		description: [ 'Filters model must be defined' ].
	^ filterModels
]

{ #category : #'api - filter model' }
TGtWithFiltersModel >> filtersModel: aFiltersModel [
	filterModels = aFiltersModel ifTrue: [ ^ self ].

	filterModels ifNotNil: [ self unsubscribeFromFiltersModel ].
	filterModels := aFiltersModel.
	self onFiltersModelChanged.
	self subscribeToFiltersModel
]

{ #category : #'api - filter model' }
TGtWithFiltersModel >> filtersModelDo: aBlock [
	self hasFiltersModel ifTrue: [ aBlock cull: self filtersModel ]
]

{ #category : #'api - filter model' }
TGtWithFiltersModel >> hasFiltersModel [
	^ filterModels isNotNil
]

{ #category : #'api - filter model' }
TGtWithFiltersModel >> onFiltersModelChanged [
]

{ #category : #'api - filter model' }
TGtWithFiltersModel >> subscribeToFiltersModel [
]

{ #category : #'api - filter model' }
TGtWithFiltersModel >> unsubscribeFromFiltersModel [
]
