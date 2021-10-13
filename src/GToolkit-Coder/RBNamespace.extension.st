Extension { #name : #RBNamespace }

{ #category : #'*GToolkit-Coder' }
RBNamespace >> category: aString for: aClass [

	^ changes addChange: (RBClassCategoryChange category: aString for: aClass)
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> changedClasses [
	^ changedClasses
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> classObjectFor: anObject [

	(anObject isBehavior or: [anObject isTrait])
		ifTrue: [ ^ self classFor: anObject ].
	anObject isSymbol
		ifTrue: [ ^ self classNamed: anObject ].
	^ anObject
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> newClasses [
	^ newClasses
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> removePool: aString from: aRBClass [ 
	^changes removePool: aString from: aRBClass
]
