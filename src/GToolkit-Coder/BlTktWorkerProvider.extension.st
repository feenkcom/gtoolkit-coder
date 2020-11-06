Extension { #name : #BlTktWorkerProvider }

{ #category : #'*GToolkit-Coder' }
BlTktWorkerProvider class >> coderPool [

	^ self 
		serviceNamed: self coderPoolName 
		ifMissing: [ self new coderPool; service ]
]

{ #category : #'*GToolkit-Coder' }
BlTktWorkerProvider >> coderPool [
	"Coder computation processing: maxPoolSize: 1, priority: 37"
	self
		name: self class coderPoolName;
		priorityQueue;
		poolMaxSize: 1;
		nonUIPriority
]

{ #category : #'*GToolkit-Coder' }
BlTktWorkerProvider class >> coderPoolName [

	^ 'Coder updates'
]
