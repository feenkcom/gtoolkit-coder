Extension { #name : #GtCoderModel }

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderModel >> gtAttributesFor: aView [
	<gtView>
	attributes ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Attributes';
		priority: 40;
		object: [ self attributes ];
		view: #gtItemsFor:
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderModel >> gtViewContextActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewContextActionsFor: aView ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderModel >> gtViewKeybindingsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewKeybindingsFor: aView ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderModel >> gtViewMainActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewMainActionsFor: aView ]
]
