import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Subscription } from './subscription.entity';
import { Repository } from 'typeorm';
import { User } from 'src/user/user.entity';

@Injectable()
export class SubscriptionService {
    constructor(
        @InjectRepository(Subscription)
        private subscriptionRepository: Repository<Subscription>,
    ) {}


    async createSubscription(userId: number, planName: string, price: number, durationInDays: number): Promise<Subscription> {
        const subscription = this.subscriptionRepository.create({
          user: { id: userId } as User,
          planName,
          price,
          durationInDays,
          startDate: new Date(),
          endDate: new Date(Date.now() + durationInDays * 24 * 60 * 60 * 1000),
        });
        return this.subscriptionRepository.save(subscription);
      }

      
    async getAllSubscriptions(): Promise<Subscription[]> {
        return this.subscriptionRepository.find({ relations: ['user'] });
    }

    async getSubcriptionById(userId: number): Promise<Subscription[]> {
        return this.subscriptionRepository.find({ where: { user: { id: userId } }, relations: ['user'] });
    }  

    async updateSubscriptionStatus(subscriptionId: number, status: string): Promise<Subscription> {
        const subscription = await this.subscriptionRepository.findOne({ where: { id: subscriptionId } });
        if (!subscription) throw new Error('Subscription not found');
    
        subscription.status = status;
    
        // Automatically update dates if the status is set to "active"
        if (status === 'active') {
            subscription.startDate = new Date(); 
            subscription.endDate = new Date(Date.now() + subscription.durationInDays * 24 * 60 * 60 * 1000); 
        }
    
        return this.subscriptionRepository.save(subscription);
    }
}


    