Extension { #name : #GtBehaviorCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtBehaviorCoder >> asCardElement [
	^ GtClassCardElement new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtBehaviorCoder >> asCoderUIModel [
	^ GtClassCoderUIModel new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtBehaviorCoder >> asElement [
	| coderElement |
	coderElement := GtBehaviorCoderElement new classCoder: self.
	^ coderElement
]
