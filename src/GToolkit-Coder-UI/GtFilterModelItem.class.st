Class {
	#name : #GtFilterModelItem,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModelItem >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self label = anObject label
]

{ #category : #converting }
GtFilterModelItem >> asFilterModelItem [
	^ self
]

{ #category : #comparing }
GtFilterModelItem >> hash [
	^ self class hash bitXor: self label hash
]

{ #category : #accessing }
GtFilterModelItem >> icon [
	<return: #BlElement or: #nil>
	^ nil
]

{ #category : #accessing }
GtFilterModelItem >> ifIcon: anIconBlock [
	^ self
		ifIconAndLabel: anIconBlock
		ifIcon: anIconBlock
		ifLabel: [  "ignore" ]
]

{ #category : #accessing }
GtFilterModelItem >> ifIconAndLabel: anIconAndLabelBlock ifIcon: anIconBlock ifLabel: aLabelBlock [
	^ self label
		ifNil: [ 
			self icon
				ifNil: [ "ignore" ]
				ifNotNil: [ :anIcon | anIconBlock cull: anIcon ] ]
		ifNotNil: [ :aLabel | 
			self icon
				ifNil: [ aLabelBlock cull: aLabel ]
				ifNotNil: [ :anIcon | anIconAndLabelBlock cull: anIcon cull: aLabel ] ]
]

{ #category : #accessing }
GtFilterModelItem >> ifLabel: aLabelBlock [
	^ self
		ifIconAndLabel: [ :anIcon :aLabel | aLabelBlock cull: aLabel ]
		ifIcon: [ "ignore" ]
		ifLabel: aLabelBlock
]

{ #category : #accessing }
GtFilterModelItem >> ifSome: aBlock [
	^ self ifSome: aBlock ifNone: [ nil ]
]

{ #category : #accessing }
GtFilterModelItem >> ifSome: aBlock ifNone: aNoneBlock [
	^ aBlock cull: self itemValue cull: self
]

{ #category : #testing }
GtFilterModelItem >> isVirtualFilterModelItem [
	^ false
]

{ #category : #accessing }
GtFilterModelItem >> itemValue [
	^ self
]

{ #category : #accessing }
GtFilterModelItem >> label [
	"Return item label or nil"

	<return: #String or: #BlText>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtFilterModelItem >> labelSize [
	<return: #Integer>
	^ self label ifNotNil: #size ifNil: [ 0 ]
]

{ #category : #converting }
GtFilterModelItem >> onCreateFilter: aFilter [
	^ self
]
