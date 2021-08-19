Extension { #name : 'BlTktWorkerProvider' }

{ #category : '*GToolkit-Coder' }
BlTktWorkerProvider class >> coderAddOnsPool [

	^ self 
		serviceNamed: self coderAddOnsPoolName 
		ifMissing: [ self new coderAddOnsPool; service ]
]

{ #category : '*GToolkit-Coder' }
BlTktWorkerProvider >> coderAddOnsPool [
	"Coder addons computation: maxPoolSize: 2, priority: 30"
	self
		name: self class coderAddOnsPoolName;
		priorityQueue;
		poolMaxSize: 2;
		nonUIPriority
]

{ #category : '*GToolkit-Coder' }
BlTktWorkerProvider class >> coderAddOnsPoolName [

	^ 'Coder addons'
]

{ #category : '*GToolkit-Coder' }
BlTktWorkerProvider class >> coderAstPool [

	^ self 
		serviceNamed: self coderAstPoolName 
		ifMissing: [ self new coderAstPool; service ]
]

{ #category : '*GToolkit-Coder' }
BlTktWorkerProvider >> coderAstPool [
	"Coder computation processing: maxPoolSize: 2, priority: 30"
	self
		name: self class coderAstPoolName;
		priorityQueue;
		poolMaxSize: 2;
		nonUIPriority
]

{ #category : '*GToolkit-Coder' }
BlTktWorkerProvider class >> coderAstPoolName [

	^ 'Coder ast'
]
