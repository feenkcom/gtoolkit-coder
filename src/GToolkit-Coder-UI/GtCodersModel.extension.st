Extension { #name : #GtCodersModel }

{ #category : #'*GToolkit-Coder-UI' }
GtCodersModel >> asCoderUIModel [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit-Coder-UI' }
GtCodersModel >> asElement [
	^ self asCoderUIModel asElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtCodersModel >> coderLook [
	^ nil
]
