Extension { #name : #GtBehaviorCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtBehaviorCoder >> asCardElement [
	^ GtClassCardElement new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtBehaviorCoder >> asCoderUIModel [
	^ GtBehaviorCoderUIModel new coder: self
]
