Class {
	#name : #GtStreamingCodersViewModelScrollTarget,
	#superclass : #Object,
	#category : #'GToolkit-Coder-StreamingCoders-UI-Utilities'
}

{ #category : #'api - testing' }
GtStreamingCodersViewModelScrollTarget >> applicableTo: aCoderViewModel [
	^ false
]

{ #category : #printing }
GtStreamingCodersViewModelScrollTarget >> printTargetNameOn: aStream [
	aStream nextPutAll: '<no target>'
]
