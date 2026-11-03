<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class DatChoNotification extends Notification
{
    use Queueable;

    /**
     * Create a new notification instance.
     */
    public function __construct(
    public int $datChoId,
    public string $maDatCho,
    public string $trangThai,
    public string $noiDung
) {}

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
{
    return (new MailMessage)
        ->subject('Cập nhật đặt chỗ')
        ->greeting('Xin chào ' . $notifiable->ho_ten . '!')
        ->line($this->noiDung)
        ->line('Mã đặt chỗ: ' . $this->maDatCho)
        ->line('Trạng thái mới: ' . $this->trangThai)
        ->action('Xem đặt chỗ', url('/'))
        ->line('Cảm ơn bạn đã sử dụng dịch vụ.');
}

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            //
        ];
    }
}
