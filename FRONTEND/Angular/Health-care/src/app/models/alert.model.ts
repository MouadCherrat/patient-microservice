export interface Alert {
  id?: number;
  title: string;
  description: string;
  type: 'CRITICAL' | 'WARNING' | 'FALL' | 'ESCAPE';
  patientId: number; 
  createdAt?: string;
}
