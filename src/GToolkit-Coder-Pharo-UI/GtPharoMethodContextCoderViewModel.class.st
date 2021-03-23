Class {
	#name : #GtPharoMethodContextCoderViewModel,
	#superclass : #GtPharoMethodCoderViewModel,
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #accessing }
GtPharoMethodContextCoderViewModel >> context [
	^ self coderModel context
]

{ #category : #'private - evaluation' }
GtPharoMethodContextCoderViewModel >> evaluationContext [
	^ super evaluationContext
		runtimeContext: self context
]

{ #category : #initialization }
GtPharoMethodContextCoderViewModel >> initialize [
	super initialize.
	
	expanded := false
]

{ #category : #notifications }
GtPharoMethodContextCoderViewModel >> notifyContextPCRangeChangedTo: anInterval [
	self announcerUIModel
		announce: (GtMethodCoderContextPCRangeChanged new
			pcRange: anInterval)
]

{ #category : #accessing }
GtPharoMethodContextCoderViewModel >> programCounterRange [
	^ self coderModel programCounterRange
]

{ #category : #updating }
GtPharoMethodContextCoderViewModel >> updateProgramCounterRange [
	self notifyContextPCRangeChangedTo: self programCounterRange
]
